<strong class="title">
    {"Are you sure you want to remove these items?"|i18n("design/ezwebin/node/removeobject")}
</strong>
<div class="primary-box fill-bottom">
<div class="row">

<form action={concat($module.functions.removeobject.uri)|ezurl} method="post" name="ObjectRemove">

<div class="warning">
<ul>
{foreach $remove_list as $remove_item}
    {if $remove_item.childCount|gt(0)}
        <li>{"%nodename and its %childcount children. %additionalwarning"
             |i18n( 'design/ezwebin/node/removeobject',,
                    hash( '%nodename', $remove_item.nodeName,
                          '%childcount', $remove_item.childCount,
                          '%additionalwarning', $remove_item.additionalWarning ) )}</li>
    {else}
        <li>{"%nodename %additionalwarning"
             |i18n( 'design/ezwebin/node/removeobject',,
                    hash( '%nodename', $remove_item.nodeName,
                          '%additionalwarning', $remove_item.additionalWarning ) )}</li>
    {/if}
{/foreach}
</ul>
</div>

{if $move_to_trash_allowed}
  <input type="hidden" name="SupportsMoveToTrash" value="1" />
  <p><input type="checkbox" name="MoveToTrash" value="1" checked="checked" />{'Move to trash'|i18n('design/ezwebin/node/removeobject')}</p>

  <p><strong>{"Note"|i18n("design/ezwebin/node/removeobject")}:</strong> {"If %trashname is checked, removed items can be found in the trash."
                                                    |i18n( 'design/ezwebin/node/removeobject',,
                                                           hash( '%trashname', concat( '<i>', 'Move to trash' | i18n( 'design/ezwebin/node/removeobject' ), '</i>' ) ) )}</p>
{/if}


<div class="buttonblock">
  
    <input type="hidden" name="RedirectURIAfterRemove" value={'/'|ezurl} />
    <input type="hidden" name="RedirectIfCancel" value={'/'|ezurl} />
    <input class="defaultbutton" type="submit" name="ConfirmButton" value="Confirm" />
    <input class="button" type="submit" name="CancelButton" value="Cancel" />
</div>

</form>
</div>
</div>