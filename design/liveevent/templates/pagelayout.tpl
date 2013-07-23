<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />

		{include uri='design:page_head.tpl'}
		
		{ezcss_load(array('vendors/jquery.pnotify.default.css','style.css'))}
		<script src="https://maps.googleapis.com/maps/api/js?key={ezini('SiteSettings','GMapsKey')}&amp;sensor=false"></script>
		{ezscript_load(
			array('https://ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js',
				'vendors/jquery.nyroModal-1.6.2.min.js',
				'vendors/ba-linkify.min.js',
				'vendors/jquery.twitter.js',
				'vendors/jquery.countdown.js',
				'vendors/jquery.timeago.js',
				'vendors/jquery.pnotify.min.js',
				'vendors/spin.min.js',
				'vendors/jquery.timers.min.js',
				'vendors/jquery.cookie.js',
				'vendors/modernizr.js',
				'main.js'
		))}
		<!--[if lt IE 9]>
		<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
		<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
		<link rel="Shortcut icon" href={"favicon.ico"|ezimage} type="image/x-icon" />
		{def $main_node = fetch( 'content', 'node', hash( 'node_id', 2 ) )
		$top_node_id = ezini('SiteSettings','TopNode', 'liveevent.ini')
			$in_edit = false()}
		{if $top_node_id|lt(1)}
			{set $top_node_id = ezini('SiteSettings','TopNode', 'site.ini')}
		{/if}
		{def $rootnode = fetch( 'content', 'node', hash( 'node_id', $top_node_id ) )
			}
		{if or($module_result.uri|contains('content/edit'),$module_result.uri|contains('content/browse'))}
			{set $in_edit = true()}
		{/if}
		{if $main_node.data_map.header_script.has_content}
			{$main_node.data_map.header_script.content}
		{/if}
	</head>
	<body onload="setTimeout(scrollTo, 0, 0, 1);">
		<header id="header">
			<a href={'/'|ezurl} class="logo">
				<img src={'livelogo.png'|ezimage()} alt="{ezini('SiteSettings','SiteName', 'site.ini')|wash}" />
			</a>
			<strong class="about">
				{if $rootnode.data_map.description.has_content}
				{attribute_view_gui attribute=$rootnode.data_map.description}
				{/if}
			</strong>
			
			{if $in_edit|not}
			{if $rootnode.data_map.racetime.has_content}
			<div id="timewidget" class="timewidget">
				<strong>{if $rootnode.data_map.racetime.content.timestamp|gt(currentdate())}Time again{else}Race time{/if}</strong>
				<div class="countdown" id="countdown" data-start-time="{$rootnode.data_map.racetime.content.timestamp}">
					<span class="countdown_row countdown_show4">
						<span class="countdown_section">
							<span class="countdown_amount">0</span><br>
							Day
						</span>
						<span class="countdown_section">
							<span class="countdown_amount">0</span><br>
							Hour
						</span>
						<span class="countdown_section">
							<span class="countdown_amount">00</span><br>
							Min
						</span>
						<span class="countdown_section">
							<span class="countdown_amount">00</span><br>
							Sec
						</span>
					</span>
				</div>
			</div>
			{/if}
			{/if}
		</header>
		<div id="main">
			{if $in_edit|not}
			<section class="primary-column">
			{/if}
				{$module_result.content}
			{if $in_edit|not}
			</section>
			<aside class="secondary-column">
				{if $rootnode.data_map.map_url.has_content}
				<strong class="title">
					{if $rootnode.data_map.map_title.has_content}
						{attribute_view_gui attribute=$rootnode.data_map.map_title}
					{else}
					Race map
					{/if}
					<a href="{$rootnode.data_map.map_url.content}" class="expand-link" rel="external">Open in new window</a>
				</strong>
				
				<div class="primary-box">
					<iframe src="{$rootnode.data_map.map_url.content}" style="height:300px"></iframe>
				</div>
				{/if}
				{if $rootnode.data_map.facebook_url.has_content}
				<strong class="title">
					Our Facebook feed 
				</strong>
				<div class="primary-box">
					<iframe src="//www.facebook.com/plugins/likebox.php?href={$rootnode.data_map.facebook_url.content|urlencode}&amp;width=292&amp;height=395&amp;show_faces=false&amp;colorscheme=light&amp;stream=true&amp;border_color&amp;header=false&amp;appId=205165196215901" class="fill-bottom"></iframe>
				</div>
				{/if}
			</aside>
			<aside class="thirdary-column">
				{if $rootnode.data_map.partners.has_content}
				<strong class="title">
					Partners
				</strong>
				<div class="primary-box">
					{def $item = array()}
					{foreach $rootnode.data_map.partners.content.relation_list as $Relations}
					{set $item = fetch( content, node, hash( node_id, $Relations.node_id ) )}
					<a href="{$item.data_map.url.content}" rel="external" class="partner-logo">{attribute_view_gui attribute=$item.data_map.image image_class=live_partner_logo}</a>
					{/foreach}
				</div>
				{/if}
				<strong class="title">
					Twitter feed
				</strong>
				<div class="primary-box fill-bottom">
					{$rootnode.data_map.twitter_embed.content}
				</div>
			</aside>
			{/if}
		</div>
	</body>
</html>
