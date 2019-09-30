
## Add the Extension

First step is always to add the extension to your development environment. 
To do this use the tutorial located [here](https://airnativeextensions.github.io/tutorials/getting-started).



## Required ANEs

### Core ANE

The Core ANE is required by this ANE. You must include and package this extension in your application.

The Core ANE doesn't provide any functionality in itself but provides support libraries and frameworks used by our extensions.
It also includes some centralised code for some common actions that can cause issues if they are implemented in each individual extension.

You can access this extension here: [https://github.com/distriqt/ANE-Core](https://github.com/distriqt/ANE-Core).


### Android Support ANE

Due to several of our ANE's using the Android Support library the library has been separated 
into a separate ANE allowing you to avoid conflicts and duplicate definitions.
This means that you need to include the some of the android support native extensions in 
your application along with this extension. 

You will add these extensions as you do with any other ANE, and you need to ensure it is 
packaged with your application. There is no problems including this on all platforms, 
they are just **required** on Android.

This ANE requires the following Android Support extensions:

- [com.distriqt.androidsupport.V4.ane](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/com.distriqt.androidsupport.V4.ane)
- [com.distriqt.androidsupport.CustomTabs.ane](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/com.distriqt.androidsupport.CustomTabs.ane)
- [com.distriqt.androidsupport.InstallReferrer.ane](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/com.distriqt.androidsupport.InstallReferrer.ane)

You can access these extensions here: [https://github.com/distriqt/ANE-AndroidSupport](https://github.com/distriqt/ANE-AndroidSupport).

>
> **Note**: if you have been using the older `com.distriqt.AndroidSupport.ane` you should remove that
> ANE and replace it with the equivalent `com.distriqt.androidsupport.V4.ane`. This is the new 
> version of this ANE and has been renamed to better identify the ANE with regards to its contents.
>

### Extension IDs

The following should be added to your extensions node in your application descriptor to identify all the required ANEs in your application:

```xml
<extensions>
    <extensionID>io.branch.nativeExtensions.Branch</extensionID>

    <extensionID>com.distriqt.Core</extensionID>
    <extensionID>com.distriqt.androidsupport.V4</extensionID>
    <extensionID>com.distriqt.androidsupport.CustomTabs</extensionID>
    <extensionID>com.distriqt.androidsupport.InstallReferrer</extensionID>
</extensions>
```


## Android

There are several additions to the manifest required for the Branch extension. In order to correctly gather install referrer information you need to add the `com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE` permission and the following receiver to your application node: 

```xml
<uses-permission android:name="com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE" />

<application>
    <receiver android:name="io.branch.referral.InstallListener" android:exported="true">
        <intent-filter>
            <action android:name="com.android.vending.INSTALL_REFERRER" />
        </intent-filter>
    </receiver>
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

                <receiver android:name="io.branch.referral.InstallListener" android:exported="true">
                    <intent-filter>
                        <action android:name="com.android.vending.INSTALL_REFERRER" />
                    </intent-filter>
                </receiver>

            </application>
        </manifest>
    ]]></manifestAdditions>
</android>
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
    ]]></InfoAdditions>
    <requestedDisplayResolution>high</requestedDisplayResolution>
    <Entitlements><![CDATA[
        <key>com.apple.developer.associated-domains</key>
        <array>
            <string>applinks:ap8q.test-app.link</string>
            <string>applinks:ap8q-alternate.test-app.link</string>
        </array>
    ]]></Entitlements>
</iPhone>
```

