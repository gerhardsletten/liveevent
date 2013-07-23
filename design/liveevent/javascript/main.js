$(function() {
	var spinneropts = {
		lines: 9,
		length: 10, 
		width: 4,
		radius: 5,
		corners: 1, 
		rotate: 0, 
		color: '#000', 
		speed: 1, 
		trail: 42,
		shadow: false, 
		hwaccel: false, 
		className: 'spin', 
		zIndex: 2e9, 
		top: 'auto', 
		left: 'auto'
	};

	

	function gmap(el) {
		var latitude = el.attr('data-latitude'),
			longitude = el.attr('data-longitude');
		var myLatlng = new google.maps.LatLng(latitude,longitude);
		var mapOptions = {
		  center: myLatlng,
		  zoom: 13,
		  mapTypeId: google.maps.MapTypeId.TERRAIN
		};
		var map = new google.maps.Map(el[0]);
		google.maps.event.trigger(map, "resize");
		map.setOptions(mapOptions);
		var marker = new google.maps.Marker({
		    position: myLatlng,
		    map: map
		});
	}
	function timeago(el) {
		el.find("abbr.timeago").timeago();
		el.find('.inline-map').each(function(){
			gmap($(this));
		});
		el.find('.lightbox').nyroModal();
	}
	timeago($('#events'));
	
	var my_comment = false;

	$('body').on('click', '.comment-toggle', function(e){
		e.preventDefault();
		var me = $(this),
			target = $(this.hash);
		if(target.is(':visible')) {
			me.text('Show');
			target.trigger('Event.Destory').fadeOut();
		} else {
			me.text('Hide');
			bindComment(target);
		}
		
	});

	function storeCookie(form, fields) {
		var cookie_name = form.attr('name');
		$.each(fields, function(index, value) {
			var el = form.find(value);
			if(el) {
				$.cookie(cookie_name + "_" + el.attr('name'), el.val());
			}
		});
	}

	function readCookie(form, fields) {
		var cookie_name = form.attr('name');
		$.each(fields, function(index, value) {
			var el = form.find(value);
			if(el && el.val().length < 1 ) {
				el.val( $.cookie(cookie_name + "_" + el.attr('name')) );
			}
		});
	}
	
	function bindComment(el) {
		el.each(function() {
			var comments = $(this),
				url = comments.attr('data-url'),
				url_count = comments.attr('data-url-count'),
				count_el = $(comments.attr('data-count-element')),
				remember = false,
				number_of_comments = 0,
				is_loading = false,
				new_element = false,
				form = false,
				checked_for_updates = 0;

			comments.on('Event.Destroy', function(e){
				comments.off('Event.Update').off('submit').stopTime();
				comments.html('');
			}).on('Event.Update', function(e){
				if(!is_loading) {
					is_loading = true;
					$.ajax({
						type: "GET",
						url: url,
						success: function(data){
							comments[0].innerHTML = data;
							timeago(comments);
							number_of_comments = comments.find('.comment-row').length,
							form = comments.find('form'),
							remember = form.hasClass('remember-fields')
							comments.fadeIn();
							if(remember) {
								readCookie(form, ['#CommentName','#CommentEmail']);
							}
							is_loading = false;
							checked_for_updates = 0;
							comments.stopTime().trigger('Event.Trigger');
							
							bindPlaceholders(comments);
							
							count_el.text(number_of_comments);
						}
					});
				}
			}).on('Event.Trigger', function(e){
				if(!is_loading) {
					$.get(url_count, function(data) {
						checked_for_updates++;
						if(parseInt(data.comments_count) > number_of_comments) {
							var diff = parseInt(data.comments_count) - number_of_comments;
							if(!new_element) {
								new_element = $('<div class="comment-row row-sticky"></div>').hide();
								form.prepend(new_element);
							}
							if(diff < 2) {
								new_element.text(diff + ' new comment').show();
							} else {
								new_element.text(diff + ' new comments').show();
							}
							count_el.text(data.comments_count);
						}
						if(checked_for_updates < 4) {
							comments.oneTime(10000, function() {
								comments.trigger('Event.Trigger')
							});
						}
					});
				}
			}).on('submit', 'form', function(e) {
				
				e.preventDefault();
				var action = form.attr('action'),
					button = form.find('.button');
				
				if(!is_loading) {
					is_loading = true;
					formStartLoading(form, button);
					if(remember) {
						storeCookie(form, ['#CommentName','#CommentEmail']);
					}
					$.ajax({
						type: "POST",
						url: action,
						data: form.serialize() + '&'+ button.attr('name') + "=1",
						success: function(data){
							
							is_loading = false;
							comments.trigger('Event.Update');
							formEndLoading(form, button);
						}
					});
				}
			}).on('click', '.row-sticky', function(e) {
				e.preventDefault();
				new_element.fadeOut("fast",function(){
					$(this).remove();
					new_element = false;
				});
				comments.trigger('Event.Update');
			}).trigger('Event.Update');
	});
	}

	$("body").on('click', '.embedded a', function(e){
		var me = $(this),
			preplace_link = me.parents('.embedded').attr('data-replace-link');
		me.attr('href', preplace_link).attr("target","_blank");
	});

	function formStartLoading(el, button) {
		var spinner = $('<span class="spinner" />');
		el.append(spinner).addClass('loading');
		var spinner2 = new Spinner(spinneropts).spin(spinner.get(0));
		if(button) {
			button.attr('disabled','disabled');
		}
		
	}

	function formEndLoading(el, button) {
		el.removeClass('loading').find('.spinner').remove();
		if(button) {
			button.removeAttr('disabled');
		}
	}

	$('#status').submit(function(e){
		e.preventDefault();
		var me = $(this),
			url = me.attr('data-url'),
			button = me.find('.defaultbutton');
		formStartLoading(me, button);
		$.post(url, {
			nonce : $('#nonce').val(),
			text : $('#status-area').val(),
			name : $('#username-area').val(),
			email: $('#email-area').val(),
			parent_id: $('#parent_id').val()
		} ,function(data){
			if(data.error) {
				$.pnotify({
				    title: 'Something went wrong',
				    text: data.error,
				    type: 'error'
				});
			} else {
				$('#events').trigger('Events.Update');
				$('#status-area').val('');
				$.pnotify({
				    title: 'Comment added',
				    text: "Your comment was added"
				});
			}
			formEndLoading(me, button);
		});
		
	});

	$('#events').each(function(){
		var holder = $(this),
			url = holder.attr('data-url'),
			url_count = holder.attr('data-count-url'),
			url_next_page = holder.attr('data-next-page-url'),
			target = holder.find('.inner-events'),
			button = holder.find('#loading-button'),
			is_loading = false,
			last_updated = target.find('.row').first().attr('data-published'),
			new_element = false;
		
		holder.everyTime(20000, function() {
			if(!is_loading) {
				$.get(url_count + "::" + last_updated, function(data) {
					if(data.updates > 0) {
						if(!new_element) {
							new_element = $('<div id="load-stories" class="row row-sticky">3 new stories</div>').hide();
							target.prepend(new_element);
						}
						if(parseInt(data.updates) < 2) {
							new_element.text(data.updates + ' new story').show();
						} else {
							new_element.text(data.updates + ' new stories').show();
						}
					}
				});
			}
		}, 100);

		holder.bind('Events.Nextpage',function(e) {
			if(!is_loading) {
				is_loading = true;
				button.text('Loading..');
				var ts = target.find('.row').last().attr('data-published');
				$.get(url_next_page + "::" + ts, function(data) {
					button.text("Load more");
					var el = $("<div/>");
					el[0].innerHTML = data;
					el.appendTo(target);
					timeago(el);
					is_loading = false;
				});
			}
		}).bind('Events.Update', function(e){
			if(!is_loading) {
				is_loading = true;
				$.get(url + "::" + last_updated, function(data) {
					is_loading = false;
					var el = $("<div/>");
					el[0].innerHTML = data;
					last_updated = el.find('.row').first().attr('data-published');
					
					el.hide();
					target.prepend(el);
					el.slideDown('fast',function(){
						timeago(el);
					});
				});
			}
		});

		holder.on('click', '#load-stories', function(){
			if(!is_loading) {
				holder.trigger('Events.Update');
				new_element.fadeOut("fast",function(){
					$(this).remove();
					new_element = false;
				});
			}
		});

		button.on('click', function(e){
			e.preventDefault();
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

	// Fix placeholders for input for IE 9 <
	function bindPlaceholders(el) {
		if(!Modernizr.input.placeholder){
			el.find('[placeholder]').focus(function() {
			  var input = $(this);
			  if (input.val() == input.attr('placeholder')) {
				input.val('');
				input.removeClass('placeholder');
			  }
			}).blur(function() {
			  var input = $(this);
			  if (input.val() == '' || input.val() == input.attr('placeholder')) {
				input.addClass('placeholder');
				input.val(input.attr('placeholder'));
			  }
			}).blur();
			el.find('[placeholder]').parents('form').submit(function() {
			  $(this).find('[placeholder]').each(function() {
				var input = $(this);
				if (input.val() == input.attr('placeholder')) {
				  input.val('');
				}
			  })
			});

		}
	}
	bindPlaceholders($('body'));

	//Initial load of page
	sizeContent();
	$(window).resize(sizeContent);
    
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