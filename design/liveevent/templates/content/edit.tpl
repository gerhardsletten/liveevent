<strong class="title">
    {'Edit <%object_name> (%class_name)'|i18n( 'design/ezwebin/content/edit', , hash( '%object_name', $object.name, '%class_name', first_set( $class.nameList[$content_language], $class.name ) ) )|wash}
</strong>
<div class="primary-box fill-bottom">
<div class="row">
<form name="editform" id="editform" enctype="multipart/form-data" method="post" action={concat( '/content/edit/', $object.id, '/', $edit_version, '/', $edit_language|not|choose( concat( $edit_language, '/' ), '/' ), $is_translating_content|not|choose( concat( $from_language, '/' ), '' ) )|ezurl}>




    {include uri='design:content/edit_validation.tpl'}

 

    <div class="context-attributes">
        {include uri='design:content/edit_attribute.tpl' view_parameters=$view_parameters}
    </div>

    <div class="buttonblock">
    <input class="defaultbutton" type="submit" name="PublishButton" value="Save" />
    <input class="button" type="submit" name="DiscardButton" value="Cancel" />
    <input type="hidden" name="DiscardConfirm" value="0" />
    <input type="hidden" name="RedirectIfDiscarded" value="{if ezhttp_hasvariable( 'LastAccessesURI', 'session' )}{ezhttp( 'LastAccessesURI', 'session' )}{/if}" />
    <input type="hidden" name="RedirectURIAfterPublish" value="{if ezhttp_hasvariable( 'LastAccessesURI', 'session' )}{ezhttp( 'LastAccessesURI', 'session' )}{/if}" />
    </div>
</form>
</div>
</div>