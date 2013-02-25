<div class="row" data-published="{$child.object.published}">
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
		<div class="comments" id="comments-{$child.node_id}" style="display:none" data-url={concat('/ezjscore/call/ezjsctemplate::get_comments::',$child.node_id)|ezurl()} data-url-count={concat('/ezjscore/call/liveajaxfunctions::comments_count::',$child.object.id)|ezurl()} data-count-element="#comment-count-{$child.node_id}">
			Loading..
		</div>
		{/if}
	</div>
</div>