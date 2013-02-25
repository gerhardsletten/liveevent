{if $node.data_map.text.has_content}
<p>{$node.data_map.text.content|simpletags|autolink}</p>
{/if}
<div class="embedded" data-replace-link={concat(ezini('SiteSettings','EmbeddedUrlPrefix', 'liveevent.ini'),'/',$node.data_map.relation.content.main_node.url_alias)}>
	{node_view_gui view='line' content_node=$node.data_map.relation.content.main_node}
</div>