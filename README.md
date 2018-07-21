# Branch io Adobe AIR Native Extension for iOS & Android.

Installation
============

Download the raw files
----------------------
Download the latest version with source code from this Git repository [https://github.com/BranchMetrics/Branch-AIR-ANE-SDK/archive/master.zip](https://github.com/BranchMetrics/Branch-AIR-ANE-SDK/archive/master.zip) you can also clone it.

Import the ANE
--------------
Import the `Branch.ane` into your project. Depending your IDE you might need to import the `Branch.swc` as well.  
Inside your `*-app.xml` be sure to add this line `<extensionID>io.branch.nativeExtensions.Branch</extensionID>`

Register your app
----------------
You can sign up for your own app id at [https://dashboard.branch.io](https://dashboard.branch.io)

Special settings on iOS
-----------------------
Inside the `*-app.xml` you must add **your Branch App Key** (refer to the [dashboard](https://dashboard.branch.io) to get it).
```xml
<iPhone><InfoAdditions><![CDATA[
	<!-- other stuff -->
	<key>branch_key</key>
	<string>key_live_xxxx</string>
]]></InfoAdditions></iPhone>
```
For a full example of the `*-app.xml` please refer to the [demo](https://github.com/BranchMetrics/Branch-AIR-ANE-SDK/blob/master/bin/Branch-AIR-ANE-SDK-app.xml).

Special settings on Android
---------------------------
Inside the `*-app.xml` you must add **your Branch App Key** (refer to the [dashboard](https://dashboard.branch.io) to get it). And also don't forget to set the Branch activity:
```xml
<android><manifestAdditions><![CDATA[
	<!-- other stuff -->
	<application>
		<meta-data android:name="io.branch.sdk.BranchKey" android:value="key_live_xxxxx" />
		<meta-data android:name="io.branch.sdk.BranchKey.test" android:value="key_test_yyyyyyy" />
		<meta-data android:name="io.branch.sdk.TestMode" android:value="false" />
		<activity android:name="io.branch.nativeExtensions.branch.BranchActivity" android:launchMode="singleTask" android:theme="@android:style/Theme.Translucent.NoTitleBar.Fullscreen" />
	</application>
]]></manifestAdditions></android>
```
For a full example of the `*-app.xml` please refer to the [demo](https://github.com/BranchMetrics/Branch-AIR-ANE-SDK/blob/master/bin/Branch-AIR-ANE-SDK-app.xml).

Configuration (for tracking)
----------------------------
Ideally, you want to use our links any time you have an external link pointing to your app (share, invite, referral, etc) because:

1. Our dashboard can tell you where your installs are coming from
1. Our links are the highest possible converting channel to new downloads and users
1. You can pass that shared data across install to give new users a custom welcome or show them the content they expect to see

Our linking infrastructure will support anything you want to build. If it doesn't, we'll fix it so that it does: just reach out to alex@branch.io with requests.

Register a URI scheme direct deep linking (optional but recommended)
--------------------------------------------------------------------
In your project's `*-app.xml` file, you can register your app to respond to direct deep links (yourapp:// in a mobile browser) by adding a URI scheme. Also, make sure to change **yourApp** to a unique string that represents your app name.  
On iOS:
```xml
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>yourApp</string>
		</array>
	</dict>
</array>
```
On Android:
```xml
<activity>
	<intent-filter>
		<data android:scheme="yourApp" />
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
    </intent-filter>
</activity>
```
For a full example of the `*-app.xml` please refer to the [demo](https://github.com/BranchMetrics/Branch-AIR-ANE-SDK/blob/master/bin/Branch-AIR-ANE-SDK-app.xml).

Initialize SDK And Register Deep Link Routing Function
------------------------------------------------------
*For a full example refer to the demo [as3 file](https://github.com/BranchMetrics/Branch-AIR-ANE-SDK/blob/master/test/src/BranchTest.as).*

Inside your `Main.as` make the following import:
```as3
import io.branch.nativeExtensions.branch.Branch;
import io.branch.nativeExtensions.branch.BranchEvent;
```

Then create a Branch instance:  
`var branch:Branch = new Branch();`  
Note that Branch is a **Singleton**, it can only have one instance which can also be used thanks to a static:  
`Branch.getInstance();`

Then you can register two events before initializing the SDK:  
```as3
branch.addEventListener(BranchEvent.INIT_FAILED, initFailed);
branch.addEventListener(BranchEvent.INIT_SUCCESSED, initSuccessed);

private function initFailed(bEvt:BranchEvent):void {
	trace("BranchEvent.INIT_FAILED", bEvt.informations);
}

private function initSuccessed(bEvt:BranchEvent):void {
	trace("BranchEvent.INIT_SUCCESSED", bEvt.informations);
	
	// params are the deep linked params associated with the link that the user clicked before showing up
	// params will be empty if no data found
	var referringParams:Object = JSON.parse(bEvt.informations);
	
	//trace(referringParams.user);
}
```

Once is done, initialize the SDK: `branch.init();`  
Be sure to have the `INIT_SUCCESSED` event called, otherwise read the `bEvt.informations` from the `INIT_FAILED` event.

Retrieve session (install or open) parameters
---------------------------------------------
These session parameters will be available at any point later on with this command. If no params, the dictionary will be empty. This refreshes with every new session (app installs AND app opens).
```as3
var sessionParams:String = branch.getLatestReferringParams();
var sessionParamsObj:Object = JSON.parse(sessionParams);
```

Retrieve install (install only) parameters
------------------------------------------
If you ever want to access the original session params (the parameters passed in for the first install event only), you can use this line. This is useful if you only want to reward users who newly installed the app from a referral link or something.
```as3
var installParams:String = branch.getFirstReferringParams();
var installParamsObj:Object = JSON.parse(installParams);
```

Persistent identities
---------------------

Often, you might have your own user IDs, or want referral and event data to persist across platforms or uninstall/reinstall. It's helpful if you know your users access your service from different devices. This where we introduce the concept of an 'identity'.

To identify a user, just call:`branch.setIdentity("your user id");`

Logout
------
If you provide a logout function in your app, be sure to clear the user when the logout completes. This will ensure that all the stored parameters get cleared and all events are properly attributed to the right identity.

**Warning** this call will clear the referral credits and attribution on the device.  
`branch.logout();`

Close Session
-------------
On Android only, clear the deep link parameters when the app is closed, so they can be refreshed after a new link is clicked or the app is reopened. This is automatically done by the ANE [AS3 code](https://github.com/BranchMetrics/Branch-AIR-ANE-SDK/blob/master/actionscript/android/src/io/branch/nativeExtensions/branch/Branch.as) using `Event.DEACTIVATE` and `Event.ACTIVATE`.

Generate Tracked
================

Shortened links
---------------
There are a bunch of options for creating these links. You can tag them for analytics in the dashboard, or you can even pass data to the new installs or opens that come from the link click. How awesome is that? You need to pass a callback for when your link is prepared (which should return very quickly, ~ 50 ms to process).

For more details on how to create links, see the [Branch link creation guide](https://github.com/BranchMetrics/Branch-Integration-Guides/blob/master/url-creation-guide.md).

```as3
//be sure to add the event listeners:
branch.addEventListener(BranchEvent.GET_SHORT_URL_FAILED, getShortUrlFailed);
branch.addEventListener(BranchEvent.GET_SHORT_URL_SUCCESSED, getShortUrlSuccessed);

private function getShortUrlSuccessed(bEvt:BranchEvent):void {
	trace("BranchEvent.GET_SHORT_URL_SUCCESSED", "my short url is: " + bEvt.informations);
}

private function getShortUrlFailed(bEvt:BranchEvent):void {
	trace("BranchEvent.GET_SHORT_URL_FAILED", bEvt.informations);
}

var dataToInclude:Object = {
	user:"Joe",
	profile_pic:"https://avatars3.githubusercontent.com/u/7772941?v=3&s=200",
	description:"Joe likes long walks on the beach...",
	
	// customize the display of the Branch link
	"$og_title":"Joe's My App Referral",
	"$og_image_url":"https://branch.io/img/logo_white.png",
	"$og_description":"Join Joe in My App - it's awesome"
};

var tags:Array = ["version1", "trial6"];

branch.getShortUrl(tags, "text_message", BranchConst.FEATURE_TAG_SHARE, "level_3", JSON.stringify(dataToInclude));
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

Referral system rewarding functionality
=======================================
In a standard referral system, you have 2 parties: the original user and the invitee. Our system is flexible enough to handle rewards for all users. Here are a couple example scenarios:

1) Reward the original user for taking action (eg. inviting, purchasing, etc)

2) Reward the invitee for installing the app from the original user's referral link

3) Reward the original user when the invitee takes action (eg. give the original user credit when their the invitee buys something)

These reward definitions are created on the dashboard, under the 'Reward Rules' section in the 'Referrals' tab on the dashboard.

Warning: For a referral program, you should not use unique awards for custom events and redeem pre-identify call. This can allow users to cheat the system.

Get reward balance
------------------
Reward balances change randomly on the backend when certain actions are taken (defined by your rules), so you'll need to make an asynchronous call to retrieve the balance. Here is the syntax:
```as3
branch.addEventListener(GET_CREDITS_SUCCESSED, getCreditsEvent);
branch.addEventListener(GET_CREDITS_FAILED, getCreditsEvent);

function getCreditsEvent(bEvt:BranchEvent):void {
	
	trace(bEvt.informations);
}

branch.getCredits();
```

Redeem all or some of the reward balance (store state)
------------------------------------------------------
We will store how many of the rewards have been deployed so that you don't have to track it on your end. In order to save that you gave the credits to the user, you can call redeem. Redemptions will reduce the balance of outstanding credits permanently.
```as3
branch.redeemRewards(5);
```

Get credit history
------------------
This call will retrieve the entire history of credits and redemptions from the individual user. To use this call, implement like so:
```as3
branch.addEventListener(GET_CREDITS_HISTORY_SUCCESSED, getCreditsHistoryEvent);
branch.addEventListener(GET_CREDITS_HISTORY_FAILED, getCreditsHistoryEvent);

function getCreditsHistoryEvent(bEvt:BranchEvent):void {
	
	trace(bEvt.informations);
}

branch.getCreditsHistory();
```

The response will return an array that has been parsed from the following JSON:
```json
[
    {
        "transaction": {
                           "date": "2014-10-14T01:54:40.425Z",
                           "id": "50388077461373184",
                           "bucket": "default",
                           "type": 0,
                           "amount": 5
                       },
        "event" : {
            "name": "event name",
            "metadata": { your event metadata if present }
        },
        "referrer": "12345678",
        "referree": null
    },
    {
        "transaction": {
                           "date": "2014-10-14T01:55:09.474Z",
                           "id": "50388199301710081",
                           "bucket": "default",
                           "type": 2,
                           "amount": -3
                       },
        "event" : {
            "name": "event name",
            "metadata": { your event metadata if present }
        },
        "referrer": null,
        "referree": "12345678"
    }
]
```
**referrer**
: The id of the referring user for this credit transaction. Returns null if no referrer is involved. Note this id is the user id in developer's own system that's previously passed to Branch's identify user API call.

**referree**
: The id of the user who was referred for this credit transaction. Returns null if no referree is involved. Note this id is the user id in developer's own system that's previously passed to Branch's identify user API call.

**type**
: This is the type of credit transaction

1. _0_ - A reward that was added automatically by the user completing an action or referral
1. _1_ - A reward that was added manually
2. _2_ - A redemption of credits that occurred through our API or SDKs
3. _3_ - This is a very unique case where we will subtract credits automatically when we detect fraud

Get referral code
-----------------
Retrieve the referral code created by current user
```as3
branch.addEventListener(GET_REFERRAL_CODE_SUCCESSED, getReferralCodeEvent);
branch.addEventListener(GET_REFERRAL_CODE_FAILED, getReferralCodeEvent);

function getReferralCodeEvent(bEvt:BranchEvent):void {
	
	trace(bEvt.informations); // stringified JSON
}

branch.getReferralCode();
```

Create referral code
--------------------
Create a new referral code for the current user, only if this user doesn't have any existing non-expired referral code.

In the simplest form, just specify an amount for the referral code.
The returned referral code is a 6 character long unique alpha-numeric string wrapped inside the params dictionary with key @"referral_code".

**amount** _int_
: The amount of credit to redeem when user applies the referral code
```as3
// Create a referral code of 5 credits
branch.addEventListener(CREATE_REFERRAL_CODE_SUCCESSED, createReferralCodeEvent);
branch.addEventListener(CREATE_REFERRAL_CODE_FAILED, createReferralCodeEvent);

function createReferralCodeEvent(bEvt:BranchEvent):void {
	
	trace(bEvt.informations); // stringified JSON
}

branch.createReferralCode("", 5);
```

Alternatively, you can specify a prefix for the referral code.
The resulting code will have your prefix, concatenated with a 2 character long unique alpha-numeric string wrapped in the same data structure.

**prefix** _String_
: The prefix to the referral code that you desire
```as3
branch.addEventListener(CREATE_REFERRAL_CODE_SUCCESSED, createReferralCodeEvent);
branch.addEventListener(CREATE_REFERRAL_CODE_FAILED, createReferralCodeEvent);

function createReferralCodeEvent(bEvt:BranchEvent):void {
	
	trace(bEvt.informations); // stringified JSON
}

branch.createReferralCode("BRANCH", 5); // prefix should not exceed 48 characters
```

If you want to specify an expiration date for the referral code, you can add an expiration parameter.
The prefix parameter is optional here, i.e. it could be getReferralCode(5, expirationDate, new BranchReferralInitListener()...

**expiration** _Date_
: The expiration date of the referral code
```as3
branch.addEventListener(CREATE_REFERRAL_CODE_SUCCESSED, createReferralCodeEvent);
branch.addEventListener(CREATE_REFERRAL_CODE_FAILED, createReferralCodeEvent);

function createReferralCodeEvent(bEvt:BranchEvent):void {
	
	trace(bEvt.informations); // stringified JSON
}

branch.createReferralCode("BRANCH", 5, expirationDate); // prefix should not exceed 48 characters
```

You can also tune the referral code to the finest granularity, with the following additional parameters:

**bucket** _String_ (max 63 characters)
: The name of the bucket to use. If none is specified, defaults to 'default'

**calculation_type**  _int_
: This defines whether the referral code can be applied indefinitely, or only once per user

1. _REFERRAL_CODE_AWARD_UNLIMITED_ - referral code can be applied continually
1. _REFERRAL_CODE_AWARD_UNIQUE_ - a user can only apply a specific referral code once

**location** _int_
: The user to reward for applying the referral code

1. _REFERRAL_CODE_LOCATION_REFERREE_ - the user applying the referral code receives credit
1. _REFERRAL_CODE_LOCATION_REFERRING_USER_ - the user who created the referral code receives credit
1. _REFERRAL_CODE_LOCATION_BOTH_ - both the creator and applicant receive credit

```as3
branch.addEventListener(CREATE_REFERRAL_CODE_SUCCESSED, createReferralCodeEvent);
branch.addEventListener(CREATE_REFERRAL_CODE_FAILED, createReferralCodeEvent);

function createReferralCodeEvent(bEvt:BranchEvent):void {
	
	trace(bEvt.informations); // stringified JSON
}

branch.createReferralCode("BRANCH", 5, expirationDate, "default", BranchConst.REFERRAL_CODE_AWARD_UNLIMITED, BranchConst.REFERRAL_CODE_LOCATION_REFERRING_USER);
```

Validate referral code
----------------------
Validate if a referral code exists in Branch system and is still valid.
A code is vaild if:

1. It hasn't expired.
1. If its calculation type is uniqe, it hasn't been applied by current user.

If valid, returns the referral code JSONObject in the call back.

**code** _String_
: The referral code to validate
```as3
branch.addEventListener(VALIDATE_REFERRAL_CODE_SUCCESSED, validateReferralCodeEvent);
branch.addEventListener(VALIDATE_REFERRAL_CODE_FAILED, validateReferralCodeEvent);

function validateReferralCodeEvent(bEvt:BranchEvent):void {
	
	trace(bEvt.informations); // stringified JSON
}

branch.validateReferralCode(code);
```

Apply referral code
-------------------
Apply a referral code if it exists in Branch system and is still valid (see above).
If the code is valid, returns the referral code JSONObject in the call back.

**code** _String_
: The referral code to apply
```as3
branch.addEventListener(APPLY_REFERRAL_CODE_SUCCESSED, applyReferralCodeEvent);
branch.addEventListener(APPLY_REFERRAL_CODE_FAILED, applyReferralCodeEvent);

function applyReferralCodeEvent(bEvt:BranchEvent):void {
	
	trace(bEvt.informations); // stringified JSON
}

branch.applyReferralCode(code);
```

Compiling the ANE
=================
To compile this ANE, you need to have [ANT](http://ant.apache.org/) installed on your (OS X) machine, and [Java 1.6](https://support.apple.com/kb/DL1572).  
Clone the repository, and change the [build.config](https://github.com/BranchMetrics/Branch-AIR-ANE-SDK/blob/master/build/build.config) to match your computer settings with the path to your AIR SDK (you should have the latest one), to the Android SDK, and to a keystore (a certificate for Air, which may be a self-signed certificate created with adt).  
Finally open a command line, `cd` in the directory and just call `ant`.
