{if is_set( $arguments[1] )}
	{def $parent_id = $arguments[0]
		$ts = $arguments[1]}
  {def $classes = array('image','live_status','live_place','live_relation','live_question')
	$children=fetch_alias( 'children', hash( 'parent_node_id', $parent_id,
	'class_filter_type', 'include',
	'class_filter_array', $classes,
	'limit', 10,
	'sort_by', array( 'published', false() ),
	'attribute_filter', 
		array( 
			array( 'published', '<', $ts ) 
		)
	)) }
	{foreach $children as $child}
		{include uri='design:parts/row.tpl' child=$child}
	{/foreach}
{/if}