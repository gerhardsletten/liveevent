Liveevents for eZ Publish
=========================

A design extension for eZ Publish for displaying updates from race and let users ask questions.

## Install

Activate the package for a site access:

	[ExtensionSettings]
	ActiveAccessExtensions[]=liveevent

And install content classes in package/livepage-1.0-1.ezpkg

Then create a new content object with type "Live page" and set its Node ID as IndexPage and DefaultPage in [SiteSettings]:

	[SiteSettings]
	SiteName=Extremeidfjord
	SiteURL=www.xtremeidfjord.no/live
	LoginPage=embedded
	IndexPage=/content/view/full/116/
	DefaultPage=/content/view/full/116/

In your main design extension add and image named livelogo.png which will be displayed in the upper left corner.

	extension/your-design-extension/design/desing-name/images/livelogo.png

## Dependencies

[eZ JS Core](http://github.com/ezsystems/ezjscore)
[eZ Comments](http://github.com/ezsystems/ezcomments)

## Credits

This is extension was developed for [Xtremeidfjord.no](http://www.xtremeidfjord.no) and [Norseman Xtreme Triathlon](http://www.nxtri.com)

By [eZ Publish extension by Metabits.no](http://www.metabits.no)
