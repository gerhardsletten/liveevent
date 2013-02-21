{if $node.data_map.text.has_content}
<p>{$node.data_map.text.content|simpletags|autolink}</p>
{/if}