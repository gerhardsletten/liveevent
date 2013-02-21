$(function() {


	$('body').on('click', '.toggle', function(e){
			e.preventDefault();
			var me = $(this),
				target = $(this.hash);
			if(target.is(':hidden')) {
				target.fadeIn();
				me.text('Hide');
			} else {
				target.fadeOut();
				me.text('Show');
			}
	});

	$("body").on('click', '.embedded a', function(e){
		var me = $(this),
			preplace_link = me.parents('.embedded').attr('data-replace-link');
			link.attr('href', preplace_link).attr("target","_blank");

	});

	$('#events').each(function(){
		var holder = $(this),
			url = holder.attr('data-url'),
			page = holder.attr('data-page'),
			pages = holder.attr('data-pages'),
			target = holder.find('.inner-events'),
			button = holder.find('#loading-button'),
			is_loading = false;
		
		holder.bind('Events.Nextpage',function(e) {
			if(!is_loading && page <= pages) {
				is_loading = true;
				button.text('Loading..');
				page++;
				$.get(url + "::" + page, function(data) {
					button.text("Load more");
					var el = $("<div/>");
					el[0].innerHTML = data;
					el.appendTo(target);
					is_loading = false;
					if(page > pages) {
						button.fadeOut();
					}
				});
			}
		}).bind('Event.Reset', function(e){
			if(!is_loading) {
				page = 0;
				is_loading = true;
				button.fadeIn().text('Loading..');
				$.get(url + "::" + page, function(data) {
					button.text("Load more");
					target[0].innerHTML = data;
					is_loading = false;
				});
			}
		});
		button.on('click', function(e){
			e.preventDefault();
			console.log(",,");
			if(!is_loading) {
				holder.trigger('Events.Nextpage');
			}
		});
	});

	$('#countdown').each(function(){
		var me = $(this),
			todate = new Date(me.attr('data-start-time')*1000),
			labels = ['Year', 'Month', 'weeks', 'Day', 'Hour', 'Min', 'Sec'];
			if(todate > new Date() ) {
				me.countdown({until: todate, labels:labels, labels1:labels, format:'dHMs' });
			} else {
				me.countdown({since: todate, labels:labels, labels1:labels, format:'dHMs' });
			}
			
	});

	if ( !$.curCSS ) {
		$.curCSS = $.css;
	}
	
	$("a[rel='external']").each( function(i) { 
		jQuery(this).attr("target","_blank");
	});

	$('.twitter-widget').each(function(){
		var me = $(this),
			username = me.attr('data-username');
		me.twitter({from: username,avatar : false,replies : false,limit:8});
		me.on('click', 'a', function() { 
		$(this).attr("target","_blank");
		});
	})

	$('a.lightbox').nyroModal();
	
	initSettingSize = {
	  windowResizing: true
	};
	$.nyroModalSettings(initSettingSize);

	//Initial load of page
	sizeContent();
	$(window).resize(sizeContent);

	$("abbr.timeago").timeago();
	    
});
var breakpoint = 600;
//Dynamically assign height
	function sizeContent() {
	    var windowheight = $(window).height();
	    $(".fill-bottom").each(function(){
	    	var me = $(this);
	    	if($(window).width() > breakpoint) {
	    		var offset = me.offset(),
	    		elHeight = windowheight - offset.top;
	    		me.height(elHeight - 15);
	    	} else {
	    		me.css('height','auto');
	    	}
	    	

	    });
	}