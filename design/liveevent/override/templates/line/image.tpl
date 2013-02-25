<a href={$node.data_map.image.content['lightbox'].full_path|ezroot} class="lightbox">
{attribute_view_gui image_class=small attribute=$node.data_map.image}
</a>
<p><strong>{$node.name|wash}</strong></p>
{attribute_view_gui attribute=$node.data_map.caption}