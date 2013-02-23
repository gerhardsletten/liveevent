{if is_set( $arguments[0] )}
  {def $node = fetch( 'content', 'node', hash( 'node_id', $arguments[0] ) )}
  {node_view_gui view='comments' content_node=$node ajax=true()}
{/if}