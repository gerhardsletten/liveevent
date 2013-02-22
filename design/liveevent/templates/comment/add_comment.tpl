{* Adding comment START *}
{def $user=fetch( 'user', 'current_user' )}
{def $anonymous_user_id=ezini('UserSettings', 'AnonymousUserID' )}
{def $is_anonymous=$user.contentobject_id|eq( $anonymous_user_id )}
{def $comment_notified=ezini( 'GlobalSettings', 'EnableNotification', 'ezcomments.ini' )}
{def $fields = ezini( 'FormSettings', 'AvailableFields', 'ezcomments.ini' )}
{def $language_id = $attribute.language_id}
{def $language_code = $attribute.language_code}
{def $fieldRequiredText = '<span class="ezcom-field-mandatory">*</span>'}

<form method="post" action={'/comment/add'|ezurl} name="CommentAdd" class="CommentAdd">
<input type="hidden" name="ContentObjectID" value="{$contentobject_id}" />
<input type="hidden" name="CommentLanguageCode" value="{$language_code}" />
<input type="hidden" name="RedirectURI" value={$redirect_uri|ezurl( , 'full' )} />


        {if $fields|contains( 'title' )}
        {def $titleRequired = ezini( 'title', 'Required', 'ezcomments.ini' )|eq( 'true' )}
        <div class="block {if $titleRequired}required{/if}">
          <input type="text" maxlength="100" name="CommentTitle" placeholder="Title" />
        </div>
        {undef $titleRequired}
        {/if}



        {if $fields|contains( 'name' )}
        {if $is_anonymous}
        {def $nameRequired = ezini( 'name', 'Required', 'ezcomments.ini' )|eq( 'true' )}
        <div class="block {if $nameRequired}required{/if}">
          <input type="text" maxlength="50" id="CommentName" name="CommentName" placeholder="Name" />
        </div>
        {undef $nameRequired}
        {else}
           <input type="hidden" id="CommentName" name="CommentName" value="{$user.contentobject.name|wash}" />
        {/if}
        {/if}

        {if $fields|contains( 'website' )}
        {def $websiteRequired = ezini( 'website', 'Required', 'ezcomments.ini' )|eq( 'true' )}
        <div class="block {if $websiteRequired}required{/if}">
          <input type="text" maxlength="100" id="CommentWebsite" name="CommentWebsite" placeholder="Website" />
        </div>
        {undef $websiteRequired}
        {/if}

        {if $fields|contains( 'email' )}
        {if $is_anonymous}
        {def $emailRequired = ezini( 'email', 'Required', 'ezcomments.ini' )|eq( 'true' )}
            <div class="block {if $emailRequired}required{/if}">
                    <input type="text" maxlength="100" id="CommentEmail" name="CommentEmail" placeholder="Your email" />
            </div>
        {undef $emailRequired}
        {else}
           <input type="hidden" name="CommentEmail" />
        {/if}
        {/if}

        <div class="block {if $emailRequired}required{/if}">
            <textarea class="box" name="CommentContent" placeholder="Add a comment"></textarea>
        </div>

        {if $fields|contains( 'notificationField' )}
            {* When email is enabled or email is enabled but user logged in *}
            {if or( $fields|contains( 'email' ), and( $fields|contains( 'email' )|not, $is_anonymous|not ) )}
                <div class="block">
                    <label>
                        <input type="checkbox" name="CommentNotified" {if $comment_notified|eq('true')}checked="checked"{/if} value="1" />
                        {'Notify me of new comments'|i18n( 'ezcomments/comment/add/form' )}
                    </label>
                </div>
            {/if}
        {/if}
        {if $fields|contains( 'recaptcha' )}
            {*Fetch captcha limitation*}
             {def $bypass_captcha = fetch( 'comment', 'has_access_to_security', hash( 'limitation', 'AntiSpam',
                                                                                        'option_value', 'bypass_captcha' ) )}
             {if $bypass_captcha|not}
                <div class="ezcom-field">
                  <fieldset>
                  <legend>{'Security text:'|i18n( 'ezcomments/comment/add/form' )}{$fieldRequiredText}</legend>
                  {if ezini( 'RecaptchaSetting', 'PublicKey', 'ezcomments.ini' )|eq('')}
                        <div class="message-warning">
                            {'reCAPTCHA API key missing.'|i18n( 'ezcomments/comment/add' )}
                        </div>
                  {else}
                      <script type="text/javascript">
                                {def $theme = ezini( 'RecaptchaSetting', 'Theme', 'ezcomments.ini' )}
                                {def $language = ezini( 'RecaptchaSetting', 'Language', 'ezcomments.ini' )}
                                {def $tabIndex = ezini( 'RecaptchaSetting', 'TabIndex', 'ezcomments.ini' )}
                                var RecaptchaOptions = {literal}{{/literal} theme : '{$theme}',
                                                         lang : '{$language}',
                                                         tabindex : {$tabIndex} {literal}}{/literal};
                      </script>
                      {if $theme|eq('custom')}
                          {*Customized theme start*}
                          <p>
                               {'Enter both words below, with or without a space.'|i18n( 'ezcomments/comment/add/form' )}<br />
                               {'The letters are not case-sensitive.'|i18n( 'ezcomments/comment/add/form' )}<br />
                               {'Can\'t read this?'|i18n( 'ezcomments/comment/add/form' )}
                               <a href="javascript:;" onclick="Recaptcha.reload();">
                                {'Try another'|i18n( 'ezcomments/comment/add/form' )}
                               </a>
                          </p>
                          <div id="recaptcha_image"></div>
                          <p>
                               <input type="text" class="box" id="recaptcha_response_field" name="recaptcha_response_field" />
                          </p>
                          {*Customized theme end*}
                       {/if}
                       {fetch( 'comment', 'recaptcha_html' )}
                  {/if}
                 </fieldset>
                </div>
             {/if}
             {undef $bypass_captcha}
        {/if}
        {if $is_anonymous}
            <div class="block">
                <label>
                    <input type="checkbox" name="CommentRememberme" checked="checked" value="1" />
                    {'Remember me'|i18n( 'ezcomments/comment/add/form' )}
                </label>
            </div>
        {/if}
        <div class="ezcom-field">
            <input type="submit" value="{'Add comment'|i18n( 'ezcomments/comment/add/form' )}" class="button" name="AddCommentButton" />
        </div>
</form>

{ezscript_require( array( 'ezjsc::yui3', 'ezjsc::yui3io', 'ezcomments.js' ) )}

<script type="text/javascript">
eZComments.cfg = {ldelim}
                    postbutton: '#ezcom-post-button',
                    postform: '#ezcom-comment-form',
                    postlist: '#ezcom-comment-list',
                    postcontainer: '#ezcom-comment-list',
                    sessionprefix: '{ezini('Session', 'SessionNamePrefix', 'site.ini')}',
                    sortorder: '{ezini('GlobalSettings', 'DefaultEmbededSortOrder', 'ezcomments.ini')}',
                    fields: {ldelim} 
                                name: '#CommentName',
                                website: '#CommentWebsite',
                                email: '#CommentEmail' 
                            {rdelim}
                 {rdelim};
eZComments.init();
</script>

{undef $comment_notified $fields}
{undef $user $anonymous_user_id $is_anonymous}
{* Adding comment END *}
