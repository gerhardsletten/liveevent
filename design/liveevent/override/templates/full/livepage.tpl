{set-block scope=global variable=cache_ttl}0{/set-block}
{def $user = fetch( 'user', 'current_user' ) 
	$classes = ezini('Content','Classes', 'liveevent.ini')}
<strong class="title">
	Race updates
</strong>
<div class="primary-box fill-bottom">
	<div class="row">
		{if $node.can_create}
		<nav class="create-menu">
			<button class="outline-button" type="submit" name="NewButton">
				<span class="status-link">Status</span>
			</button>
			{if $classes|contains('image')}
			<form method="post" action={"content/action/"|ezurl}>
				<button class="outline-button" type="submit" name="NewButton">
					<span class="photo-link">Photo</span>
				</button>
				<input type="hidden" name="NodeID" value="{$node.node_id}" />
				<input type="hidden" name="ClassIdentifier" value="image" />
				<input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
			</form>
			{/if}
			{if $classes|contains('live_place')}
			<form method="post" action={"content/action/"|ezurl}>
				<button class="outline-button" type="submit" name="NewButton">
					<span class="place-link">Place</span>
				</button>
				<input type="hidden" name="NodeID" value="{$node.node_id}" />
				<input type="hidden" name="ClassIdentifier" value="live_place" />
				<input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
			</form>
			{/if}
			{if $classes|contains('live_relation')}
			<form method="post" action={"content/action/"|ezurl}>
				<button class="outline-button" type="submit" name="NewButton">
					<span class="rel-link">Website relation</span>
				</button>
				<input type="hidden" name="NodeID" value="{$node.node_id}" />
				<input type="hidden" name="ClassIdentifier" value="live_relation" />
				<input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
			</form>
			{/if}
		</nav>

		{/if}
		{cache-block keys=array( $user.contentobject_id )}
		<form action="#" id="status" data-url={concat('/ezjscore/call/liveajaxfunctions::add_content')|ezurl()}>
			<input type="hidden" id="nonce" value="{nonce()}" />
			<input type="hidden" id="parent_id" value="{$node.node_id}" />
			<div class="status-area"><textarea placeholder="{if $node.can_create}Add a status{else}Ask a question{/if}" {literal}pattern=".{3,50}"{/literal} id="status-area"></textarea></div>
			<div class="post-holder">
				{if $user.contentobject_id|eq(10)}
					<input type="text" id="username-area" {literal}pattern=".{3,50}"{/literal} placeholder="Your name" />
				{else}
					<input type="hidden" id="username-area" value="{$user.contentobject.name|wash}" />
				{/if}
				<input type="submit" class="defaultbutton" value="Post" />
				{if $user.is_logged_in}
				<p class="meta">Logged in as <strong>{$user.contentobject.name|wash}</strong> | <a href={"/user/logout"|ezurl}>Logout</a></p>
				{/if}
			</div>
		</form>
		{/cache-block}
	</div>
	{def $page_limit = 10
		$children = fetch_alias( 'children', hash( 'parent_node_id', $node.node_id,
		'offset', $view_parameters.offset,
		'sort_by', array( 'published', false() ),
		'class_filter_type', 'include',
		'class_filter_array', $classes,
		'limit', $page_limit ) )}

	<section id="events" data-url={concat('/ezjscore/call/ezjsctemplate::updates::',$node.node_id)|ezurl()} data-count-url={concat('/ezjscore/call/liveajaxfunctions::updates_count::',$node.node_id)|ezurl()}  data-next-page-url={concat('/ezjscore/call/ezjsctemplate::downdates::',$node.node_id)|ezurl()}>
		<div class="inner-events">
			{foreach $children as $child}
				{include uri='design:parts/row.tpl' child=$child}
			{/foreach}
		</div>
			<div class="row">
				<a href={concat($node.url_alias, '/(offset)/',sum($view_parameters.offset, $page_limit))|ezurl} class="button" id="loading-button">Load more</a>
			</div>
	</section>
</div>