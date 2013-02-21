{if is_set( $arguments[1] )}
  {def $node = fetch( 'content', 'node', hash( 'node_id', $arguments[0] ) )}
  {node_view_gui view='eventlist' content_node=$node page=$arguments[1] ajax=true()}
{/if}