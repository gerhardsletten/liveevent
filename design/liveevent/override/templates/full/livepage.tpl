{def $user = fetch( 'user', 'current_user' ) }
<strong class="title">
	Latest race updates
</strong>
<div class="primary-box fill-bottom">
	<div class="row">
		{if $node.can_create}
		<nav class="create-menu">
			<button class="outline-button" type="submit" name="NewButton">
				<span class="status-link">Status</span>
			</button>
			<form method="post" action={"content/action/"|ezurl}>
				<button class="outline-button" type="submit" name="NewButton">
					<span class="photo-link">Photo</span>
				</button>
				<input type="hidden" name="NodeID" value="{$node.node_id}" />
				<input type="hidden" name="ClassIdentifier" value="image" />
				<input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
			</form>
			<form method="post" action={"content/action/"|ezurl}>
				<button class="outline-button" type="submit" name="NewButton">
					<span class="place-link">Place</span>
				</button>
				<input type="hidden" name="NodeID" value="{$node.node_id}" />
				<input type="hidden" name="ClassIdentifier" value="live_place" />
				<input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
			</form>
			<form method="post" action={"content/action/"|ezurl}>
				<button class="outline-button" type="submit" name="NewButton">
					<span class="rel-link">Website relation</span>
				</button>
				<input type="hidden" name="NodeID" value="{$node.node_id}" />
				<input type="hidden" name="ClassIdentifier" value="live_relation" />
				<input type="hidden" name="ContentLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale', 'site.ini')}" />
			</form>
		</nav>

		{/if}

		<form action="#" id="status" data-url={concat('/ezjscore/call/liveajaxfunctions::add_content')|ezurl()}>
			<input type="hidden" id="nonce" value="{nonce()}" />
			<input type="hidden" id="parent_id" value="{$node.node_id}" />
			<div class="status-area"><textarea placeholder="Add a status" id="status-area"></textarea></div>
			<div class="post-holder">

				{if $node.can_create}
					<input type="hidden" id="username-area" value="{$user.contentobject.name|wash}" />
				{else}
					<input type="text" id="username-area" placeholder="Your name" />
				{/if}
				<input type="submit" class="defaultbutton" value="Post" />
				{if $user.is_logged_in}
				<p class="meta">
					
						{def $access=fetch( 'user', 'has_access_to', hash(
							'module','content',
							'function', 'read',
							'user_id', $user.contentobject_id ) )}
						Logged in as <strong>{$user.contentobject.name|wash}</strong> | <a href={"/user/logout"|ezurl}>Logout</a>
					
				</p>
				{/if}
			</div>
		</form>
		
				{*<a href={"/layout/set/ajax/user/login"|ezurl} class="lightbox">Login</a> or <a href={"/layout/set/ajax/user/register"|ezurl} class="lightbox">register</a> to comment*}
			
	</div>
	{node_view_gui view='eventlist' content_node=$node page="0"}
</div>