---
title: Get Short URL
sidebar_label: Get Short URL
---

## Shortened links

>
> Note: This functionality has been deprecated. It is to be considered legacy functionality and has been replaced by Branch Universal Objects
>

There are a bunch of options for creating these links. You can tag them for analytics in the dashboard, or you can even pass data to the new installs or opens that come from the link click. 

You need to pass a callback for when your link is prepared (which should return very quickly, ~ 50 ms to process).

For more details on how to create links, see the [Branch link creation guide](https://github.com/BranchMetrics/Branch-Integration-Guides/blob/master/url-creation-guide.md).

```actionscript
Branch.instance.addEventListener( BranchEvent.GET_SHORT_URL_FAILED, getShortUrlFailed );
Branch.instance.addEventListener( BranchEvent.GET_SHORT_URL_SUCCESS, getShortUrlSuccess );

function getShortUrlSuccess( event:BranchEvent ):void 
{
	trace( "short url: " + event.data );
}

function getShortUrlFailed( event:BranchEvent ):void 
{
	trace( "ERROR:" + event.data);
}

var dataToInclude:Object = 
{
	user:"Joe",
	profile_pic:"https://avatars3.githubusercontent.com/u/7772941?v=3&s=200",
	description:"Joe likes long walks on the beach...",
	
	// customize the display of the Branch link
	"$og_title":"Joe's My App Referral",
	"$og_image_url":"https://branch.io/img/logo_white.png",
	"$og_description":"Join Joe in My App - it's awesome"
};

var tags:Array = ["version1", "trial6"];

Branch.instance.getShortUrl( tags, "text_message", BranchConst.FEATURE_TAG_SHARE, "level_3", JSON.stringify(dataToInclude) );
```

There are other methods which exclude tag and data if you don't want to pass those.

**Note**
You can customize the Facebook OG tags of each URL if you want to dynamically share content by using the following _optional keys in the data dictionary_:

| Key | Value
| --- | ---
| "$og_title" | The title you'd like to appear for the link in social media
| "$og_description" | The description you'd like to appear for the link in social media
| "$og_image_url" | The URL for the image you'd like to appear for the link in social media
| "$og_video" | The URL for the video 
| "$og_url" | The URL you'd like to appear
| "$og_app_id" | Your OG app ID. Optional and rarely used.

Also, you do custom redirection by inserting the following _optional keys in the dictionary_:

| Key | Value
| --- | ---
| "$desktop_url" | Where to send the user on a desktop or laptop. By default it is the Branch-hosted text-me service
| "$android_url" | The replacement URL for the Play Store to send the user if they don't have the app. _Only necessary if you want a mobile web splash_
| "$ios_url" | The replacement URL for the App Store to send the user if they don't have the app. _Only necessary if you want a mobile web splash_
| "$ipad_url" | Same as above but for iPad Store
| "$fire_url" | Same as above but for Amazon Fire Store
| "$blackberry_url" | Same as above but for Blackberry Store
| "$windows_phone_url" | Same as above but for Windows Store

You have the ability to control the direct deep linking of each link by inserting the following _optional keys in the dictionary_:

| Key | Value
| --- | ---
| "$deeplink_path" | The value of the deep link path that you'd like us to append to your URI. For example, you could specify "$deeplink_path": "radio/station/456" and we'll open the app with the URI "yourapp://radio/station/456?link_click_id=branch-identifier". This is primarily for supporting legacy deep linking infrastructure. 
| "$always_deeplink" | true or false. (default is not to deep link first) This key can be specified to have our linking service force try to open the app, even if we're not sure the user has the app installed. If the app is not installed, we fall back to the respective app store or $platform_url key. By default, we only open the app if we've seen a user initiate a session in your app from a Branch link (has been cookied and deep linked by Branch).