
## Add the Extension

First step is always to add the extension to your development environment. 
To do this use the tutorial located [here](https://airnativeextensions.github.io/tutorials/getting-started).


### AIR SDK


This ANE currently requires at least AIR 33+. This is required in order to support versions of Android > 9.0 (API 28). We always recommend using the most recent build with AIR especially for mobile development where the OS changes rapidly.



## Dependencies

Many of our extensions use some common libraries, for example, the Android Support libraries.

We have to separate these libraries into separate extensions in order to avoid multiple versions of the libraries being included in your application and causing packaging conflicts. This means that you need to include some additional extensions in your application along with the main extension file.

You will add these extensions as you do with any other extension, and you need to ensure it is packaged with your application.


### Core 

The Core extension is required by this extension. You must include this extension in your application.

The Core extension doesn't provide any functionality in itself but provides support libraries and frameworks used by our extensions.
It also includes some centralised code for some common actions that can cause issues if they are implemented in each individual extension.

You can access this extension here: [https://github.com/distriqt/ANE-Core](https://github.com/distriqt/ANE-Core).


### Android Support

The Android Support libraries encompass the Android Support, Android X and common Google libraries. 

These libraries are specific to Android. There are no issues including these on all platforms, they are just **required** for Android.

This extension requires the following extensions:

- [androidx.appcompat.ane](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/androidx.appcompat.ane)
- [androidx.browser.ane](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/androidx.browser.ane)
- [androidx.core.ane](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/androidx.core.ane)
- [com.android.installreferrer.ane](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/com.android.installreferrer.ane)

You can access these extensions here: [https://github.com/distriqt/ANE-AndroidSupport](https://github.com/distriqt/ANE-AndroidSupport).


>
> **Note**: if you have been using the older `com.distriqt.androidsupport.*` (Android Support) extensions you should remove these extensions and replace it with the `androidx` extensions listed above. This is the new version of the android support libraries and moving forward all our extensions will require AndroidX.
>


### Google Play Services

This ANE requires can use of certain aspects of the Google Play Services if supplied, mainly around using the advertising identifier to attribute links correctly. 

The client library is available as a series of ANEs that you add into your applications packaging options. 
Each separate ANE provides a component from the Play Services client library and are used by different ANEs. 
These client libraries aren't packaged with this ANE as they are used by multiple ANEs and separating them 
will avoid conflicts, allowing you to use multiple ANEs in the one application.

If you wish to use the expanded functionality add the following Google Play Services:

- [`com.distriqt.playservices.Base`](https://github.com/distriqt/ANE-GooglePlayServices/raw/master/lib/com.distriqt.playservices.Base.ane)
- [`com.distriqt.playservices.AdsIdentifier`](https://github.com/distriqt/ANE-GooglePlayServices/raw/master/lib/com.distriqt.playservices.AdsIdentifier.ane)

You can access the Google Play Services client library extensions here: [https://github.com/distriqt/ANE-GooglePlayServices](https://github.com/distriqt/ANE-GooglePlayServices).

>
> **Note:** The Google Play Services and Android Support ANEs are only **required** on Android devices. 
> There is no problem packaging these ANEs with all platforms as there are default implementations available which will allow your code to package without errors 
> however if you are only building an iOS application feel free to remove the Google Play Services ANEs from your application.
>



### Extension IDs

The following should be added to your extensions node in your application descriptor to identify all the required ANEs in your application:

```xml
<extensions>
    <extensionID>io.branch.nativeExtensions.Branch</extensionID>

    <extensionID>com.distriqt.Core</extensionID>

    <extensionID>androidx.core</extensionID>
    <extensionID>androidx.appcompat</extensionID>
    <extensionID>androidx.browser</extensionID>
    <extensionID>com.android.installreferrer</extensionID>
   
    <extensionID>com.distriqt.playservices.Base</extensionID>
    <extensionID>com.distriqt.playservices.AdsIdentifier</extensionID>
</extensions>
```


## Android

### Manifest Additions


There are several additions to the manifest required for the Branch extension. In order to correctly gather install referrer information you need to add the `com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE` permission : 

```xml
<uses-permission android:name="com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE" />

<application>
    
</application>
```


### Keys

Most importantly you need to add the Branch keys for your application as meta data tags to the `application` node in your manifest:

```xml
<meta-data android:name="io.branch.sdk.TestMode" android:value="false" />
<meta-data android:name="io.branch.sdk.BranchKey" android:value="key_live_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" />
<meta-data android:name="io.branch.sdk.BranchKey.test" android:value="key_test_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" />
```

The `io.branch.sdk.TestMode` flag can be used to set your application into test mode from the manifest. You can override this in your AS3 code however this option is here if you wish to use this method.


### Deep link scheme

If you are adding a deep link / custom url scheme to be able to launch your application from a url such as `myapp://` then you need to add the scheme to the main activity for your application:

```xml
<activity android:launchMode="singleTask">
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>

    <!-- Branch URI scheme -->
    <intent-filter>
        <data android:scheme="myapp" android:host="open" />
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
    </intent-filter>
</activity>
```


### Example

```xml
<android>
    <manifestAdditions><![CDATA[
        <manifest android:installLocation="auto">
            <uses-permission android:name="android.permission.INTERNET"/>

            <uses-permission android:name="com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE" />

            <application>
                <activity android:launchMode="singleTask">
                    <intent-filter>
                        <action android:name="android.intent.action.MAIN"/>
                        <category android:name="android.intent.category.LAUNCHER"/>
                    </intent-filter>

                    <!-- Branch URI scheme -->
                    <intent-filter>
                        <data android:scheme="myapp" android:host="open" />
                        <action android:name="android.intent.action.VIEW" />
                        <category android:name="android.intent.category.DEFAULT" />
                        <category android:name="android.intent.category.BROWSABLE" />
                    </intent-filter>
                </activity>

                <meta-data android:name="io.branch.sdk.TestMode" android:value="true" />
                <meta-data android:name="io.branch.sdk.BranchKey" android:value="key_live_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" />
                <meta-data android:name="io.branch.sdk.BranchKey.test" android:value="key_test_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" />

            </application>
        </manifest>
    )></manifestAdditions>
</android>
```



### MultiDex Applications 

If you have a large application and are supporting Android 4.x then you will need to ensure you enable your application to correctly support MultiDex to allow the application to be broken up into smaller dex packages.

This is enabled by default with releases of AIR v25+, except in the Android 4.x case where you need to change the manifest additions for the application tag to match the following and use the `MultiDexApplication`.


#### Using AndroidX

This will require the addition of the `androidx.multidex` extension which contains the `androidx.multidex.MultiDexApplication` implementation.

```xml
<manifest android:installLocation="auto">
	<!-- PERMISSIONS -->

	<application android:name="androidx.multidex.MultiDexApplication">

		<!-- ACTIVITIES / RECEIVERS / SERVICES -->

	</application>
</manifest>
```



## iOS

The Branch SDK requires a few additions to the Info plist and Entitlements section of your application to correctly configure your application. These are listed in the sections below.

Note: As of version 3.1 the extension now packages the Branch iOS framework code internal to the application. **You no longer need to add the Framework**.





### Keys

Most importantly you need to add the Branch keys for your application to the InfoAdditions node:

```xml
<key>branch_key</key>
<dict>
    <key>live</key>
    <string>key_live_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</string>
    <key>test</key>
    <string>key_test_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</string>
</dict>
```

You should replace the entries above with the values from the Branch dashboard for your application.


### Configure associated domains

Add your link domains from your Branch dashboard, these should be added to the Entitlements node, for example:

```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:ap8q.test-app.link</string>
    <string>applinks:ap8q-alternate.test-app.link</string>
</array>
```


### Deep link scheme

If you are adding a deep link / custom url scheme to be able to launch your application from a url such as `myapp://` then you need to add the scheme to the info additions as below:

```xml
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>myapp</string>
		</array>
	</dict>
</array>
```


### Example 

```xml
<iPhone>
    <InfoAdditions><![CDATA[
        <key>UIDeviceFamily</key>
        <array>
            <string>1</string>
            <string>2</string>
        </array>

        <key>CFBundleURLTypes</key>
        <array>
            <dict>
                <key>CFBundleURLSchemes</key>
                <array>
                <string>myapp</string>
                </array>
            </dict>S
        </array>

        <key>branch_key</key>
        <dict>
            <key>live</key>
            <string>key_live_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</string>
            <key>test</key>
            <string>key_test_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</string>
        </dict>
    )></InfoAdditions>
    <requestedDisplayResolution>high</requestedDisplayResolution>
    <Entitlements><![CDATA[
        <key>com.apple.developer.associated-domains</key>
        <array>
            <string>applinks:ap8q.test-app.link</string>
            <string>applinks:ap8q-alternate.test-app.link</string>
        </array>
    )></Entitlements>
</iPhone>
```

