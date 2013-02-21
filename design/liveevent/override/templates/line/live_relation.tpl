{if $node.data_map.text.has_content}
<p>{$node.data_map.text.content|simpletags|autolink}</p>
{/if}
<div class="embedded" data-replace-link={concat('/content/view/full/',$node.data_map.relation.content.main_node.node_id)|ezroot}>
	{node_view_gui view='line' content_node=$node.data_map.relation.content.main_node}
</div>