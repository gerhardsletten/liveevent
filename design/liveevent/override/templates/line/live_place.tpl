{attribute_view_gui attribute=$node.data_map.location}
{if $node.data_map.text.has_content}
<p>{$node.data_map.text.content|simpletags|autolink}</p>
{/if}