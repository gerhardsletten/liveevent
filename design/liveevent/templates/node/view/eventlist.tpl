{def $page_limit = 10
	$offset = mul($page,$page_limit)
	$classes = array('image','live_status','live_place','live_relation','live_question')
	$children = array()
	$children_count=fetch_alias( 'children_count', hash( 'parent_node_id', $node.node_id,
	'class_filter_type', 'include',
	'class_filter_array', $classes))
	$pages = $children_count|div($page_limit)|floor}

{set $children = fetch_alias( 'children', hash( 'parent_node_id', $node.node_id,
	'offset', $offset,
	'sort_by', array( 'published', false() ),
	'class_filter_type', 'include',
	'class_filter_array', $classes,
	'limit', $page_limit ) )}

{if is_unset($ajax)}
<section id="events" data-url={concat('/ezjscore/call/ezjsctemplate::eventlist::',$node.node_id)|ezurl()} data-pages="{$pages}" data-page="{$page}">
	<div class="inner-events">
{/if}
{foreach $children as $child}
	<div class="row">
		<span class="avatar">
			<img src="http://www.gravatar.com/avatar/{$child.creator.data_map.user_account.content.email|md5}?s=48" alt="{$child.creator.name|wash}" />
		</span>
		<div class="row-inner">
			<p class="meta"><abbr class="timeago" title="{$child.object.published|datetime(custom, '%Y-%m-%dT%H:%i:%sZ%O')}">{$child.object.published|l10n(shortdatetime)}</abbr> by {if $child.class_identifier|eq('live_question')}{attribute_view_gui attribute=$child.data_map.name}{else}{$child.creator.name|wash}{/if}</p>
			
			{node_view_gui view='line' content_node=$child}
			
			<div class="meta">
				{if or($child.can_edit,$child.can_remove, 1|eq(2))}
					<form method="post" action={"content/action/"|ezurl} class="actions">
						<input type="hidden" name="ContentObjectID" value="{$child.object.id}" />
						<input type="hidden" name="ContentNodeID" value="{$child.node_id}">
						<input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
						<input type="hidden" name="CancelURI" value={$node.url_alias|ezurl} />
						<input type="hidden" name="RedirectURIAfterPublish" value={$node.url_alias|ezurl} />
						<input type="hidden" name="RedirectIfDiscarded" value={$node.url_alias|ezurl} />
						
					{if $child.can_edit}
						<input class="action-link" type="submit" name="EditButton" value="Edit" />
					{/if}
					{if $child.can_edit}
						<input class="action-link" type="submit" name="ActionRemove" value="Delete" />
					{/if}
					</form>                            	
				{/if}
				{if is_set($child.data_map.comments)}
				<span class="ico-comment"><span id="comment-count-{$child.node_id}">{fetch( 'comment', 'comment_count', 
                             hash( 'contentobject_id', $child.object.id,
                                   'status', 1 ) )}</span> comments</span> <a href="#comments-{$child.node_id}" class="comment-toggle">Show</a>
                {/if}
                
            </div>
            {if is_set($child.data_map.comments)}
			<div class="comments" id="comments-{$child.node_id}" style="display:none" data-url={concat('/ezjscore/call/ezjsctemplate::livecomments::',$child.node_id)|ezurl()}>
				Loading..
			</div>
			{/if}
		</div>
	</div>
{/foreach}
{if is_unset($ajax)}
</div>
	{if $children_count|gt(sum($view_parameters.offset, $page_limit))}
		<div class="row">
			<a href={concat($node.url_alias, '/(offset)/',sum($view_parameters.offset, $page_limit))|ezurl} class="button" id="loading-button">Load more</a>
		</div>
	{/if}
</section>
{/if}