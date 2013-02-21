{if not( is_set( $self_edit ) )}
    {def $self_edit=false()}
{/if}

{if not( is_set( $self_delete ) )}
    {def $self_delete=false()}
{/if}
<div class="comment-row">
    <span class="avatar">
        <img src="http://www.gravatar.com/avatar/{$comment.email|md5}?s=28" alt="{$comment.name|wash}" />
    </span>
    <div class="row-inner">
        <p>{$comment.text|wash|nl2br}</p>
        {def $can_edit=fetch( 'comment', 'has_access_to_function', hash( 'function', 'edit',
                                                                         'contentobject', $contentobject,
                                                                         'language_code', $language_code,
                                                                         'comment', $comment,
                                                                         'scope', 'role',
                                                                         'node', $node ) )
             $can_delete=fetch( 'comment', 'has_access_to_function', hash( 'function', 'delete',
                                                                           'contentobject', $contentobject,
                                                                           'language_code', $language_code,
                                                                           'comment', $comment,
                                                                           'scope', 'role',
                                                                           'node', $node ) )
             $user_display_limit_class=concat( ' class="limitdisplay-user limitdisplay-user-', $comment.user_id, '"' )}
             
        {if or( $can_edit, $can_self_edit, $can_delete, $can_self_delete )}
            <div class="actions">
                {if or( $can_edit, $can_self_edit )}
                        <a href={concat( '/comment/edit/', $comment.id )|ezurl} class="action-link">{'Edit'|i18n('ezcomments/comment/view')}</a>
                {/if}
                {if or( $can_delete, $can_self_delete )}
                        <a href={concat( '/comment/delete/',$comment.id )|ezurl} class="action-link">
                            {'Delete'|i18n('ezcomments/comment/view')}
                        </a>
                {/if}
            </div>
        {/if}
        {undef $can_edit $can_delete}
        <p class="meta"><abbr class="timeago" title="{$comment.created|datetime(custom, '%Y-%m-%dT%H:%i:%sZ%O')}">{$comment.created|l10n(shortdatetime)}</abbr> by {$comment.name|wash}</p>
    </div>
</div>