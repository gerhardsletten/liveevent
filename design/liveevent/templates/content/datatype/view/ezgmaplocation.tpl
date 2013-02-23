{if $attribute.has_content}
<div id="ezgml-map-{$attribute.id}" style="width: 170px; height: 130px;" class="inline-map" data-latitude="{$attribute.content.latitude}" data-longitude="{$attribute.content.longitude}"></div>
{if $attribute.content.address}<p>{$attribute.content.address}</p>{/if}
{/if}