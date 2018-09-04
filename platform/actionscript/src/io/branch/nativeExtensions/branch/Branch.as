package io.branch.nativeExtensions.branch
{
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.InvokeEvent;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import io.branch.nativeExtensions.branch.events.BranchCreditsEvent;
	
	import io.branch.nativeExtensions.branch.events.BranchEvent;
	
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchEvent.INIT_SUCCESS
	 */
	[Event(name="init:success", type="io.branch.nativeExtensions.branch.events.BranchEvent")]
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchEvent.INIT_FAILED
	 */
	[Event(name="init:failed", type="io.branch.nativeExtensions.branch.events.BranchEvent")]
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchEvent.SET_IDENTITY_SUCCESS
	 */
	[Event(name="setidentity:success", type="io.branch.nativeExtensions.branch.events.BranchEvent")]
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchEvent.SET_IDENTITY_FAILED
	 */
	[Event(name="setidentity:failed", type="io.branch.nativeExtensions.branch.events.BranchEvent")]
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchEvent.GET_SHORT_URL_SUCCESS
	 */
	[Event(name="getshorturl:success", type="io.branch.nativeExtensions.branch.events.BranchEvent")]
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchEvent.GET_SHORT_URL_FAILED
	 */
	[Event(name="getshorturl:failed", type="io.branch.nativeExtensions.branch.events.BranchEvent")]
	
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchCreditsEvent.GET_CREDITS_SUCCESS
	 */
	[Event(name="getcredits:success", type="io.branch.nativeExtensions.branch.events.BranchCreditsEvent")]
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchCreditsEvent.GET_CREDITS_FAILED
	 */
	[Event(name="getcredits:failed", type="io.branch.nativeExtensions.branch.events.BranchCreditsEvent")]
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchCreditsEvent.REDEEM_REWARDS_SUCCESS
	 */
	[Event(name="redeemrewards:success", type="io.branch.nativeExtensions.branch.events.BranchCreditsEvent")]
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchCreditsEvent.REDEEM_REWARDS_FAILED
	 */
	[Event(name="redeemrewards:failed", type="io.branch.nativeExtensions.branch.events.BranchCreditsEvent")]
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchCreditsEvent.GET_CREDITS_HISTORY_SUCCESS
	 */
	[Event(name="getcreditshistory:success", type="io.branch.nativeExtensions.branch.events.BranchCreditsEvent")]
	
	/**
	 * @eventType io.branch.nativeExtensions.branch.events.BranchCreditsEvent.GET_CREDITS_HISTORY_FAILED
	 */
	[Event(name="getcreditshistory:failed", type="io.branch.nativeExtensions.branch.events.BranchCreditsEvent")]
	
	
	/**
	 * <p>
	 * Main interface to the Branch SDK for the Branch native extension.
	 * </p>
	 */
	public class Branch extends EventDispatcher
	{
		////////////////////////////////////////////////////////
		//	CONSTANTS
		//
		
		public static const EXT_CONTEXT_ID:String = "io.branch.nativeExtensions.Branch";
		
		public static const VERSION:String = Version.VERSION;
		
		private static const ERROR_CREATION:String = "The native extension context could not be created";
		private static const ERROR_SINGLETON:String = "The singleton has already been created. Use Branch.instance to access the functionality";
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		private static var _instance:Branch = null;
		private static var _shouldCreateInstance:Boolean = false;
		private static var _extensionContext:ExtensionContext;
		
		
		////////////////////////////////////////////////////////
		//	SINGLETON
		//
		
		
		public static function get instance():Branch
		{
			return getInstance();
		}
		
		
		public static function getInstance():Branch
		{
			if (_instance == null)
			{
				_shouldCreateInstance = true;
				_instance = new Branch();
				_shouldCreateInstance = false;
			}
			return _instance;
		}
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		/**
		 * <code>Branch</code> is a Singleton, it should be access through the <code>Branch.instance</code> reference.
		 */
		public function Branch()
		{
			if (_shouldCreateInstance)
			{
				try
				{
					_extensionContext = ExtensionContext.createExtensionContext( EXT_CONTEXT_ID, null );
					_extensionContext.addEventListener( StatusEvent.STATUS, extension_statusHandler );
					
					NativeApplication.nativeApplication.addEventListener( InvokeEvent.INVOKE, nativeApplication_invokeHandler );
				}
				catch (e:Error)
				{
					throw new Error( ERROR_CREATION );
				}
			}
			else
			{
				throw new Error( ERROR_SINGLETON );
			}
		}
		
		
		/**
		 * Whether the current device supports the extensions functionality
		 */
		public static function get isSupported():Boolean
		{
			getInstance();
			return _extensionContext.call( "isSupported" );
		}
		
		
		/**
		 * <p>
		 * The version of this extension.
		 * </p>
		 * <p>
		 * This should be of the format, MAJOR.MINOR.BUILD
		 * </p>
		 */
		public function get version():String
		{
			return VERSION;
		}
		
		
		/**
		 * <p>
		 * The native version string of the native extension.
		 * </p>
		 */
		public function get nativeVersion():String
		{
			try
			{
				return _extensionContext.call( "version" ) as String;
			}
			catch (e:Error)
			{
			}
			return "0";
		}
		
		
		/**
		 * <p>
		 * The implementation currently in use.
		 * This should be one of the following depending on the platform in use and the
		 * functionality supported by this extension:
		 * <ul>
		 * <li><code>Android</code></li>
		 * <li><code>iOS</code></li>
		 * <li><code>default</code></li>
		 * <li><code>unknown</code></li>
		 * </ul>
		 * </p>
		 */
		public function get implementation():String
		{
			try
			{
				return _extensionContext.call( "implementation" ) as String;
			}
			catch (e:Error)
			{
			}
			return "unknown";
		}
		
		
		/**
		 * <p>
		 * Disposes the extension and releases any allocated resources. Once this function
		 * has been called, the extension functionality will have to be re-initialised upon next use.
		 * </p>
		 */
		public function dispose():void
		{
			NativeApplication.nativeApplication.removeEventListener( InvokeEvent.INVOKE, nativeApplication_invokeHandler );
			
			if (_extensionContext)
			{
				_extensionContext.removeEventListener( StatusEvent.STATUS, extension_statusHandler );
				_extensionContext.dispose();
				_extensionContext = null;
			}
			
			_instance = null;
		}
		
		
		//
		//
		//	BRANCH FUNCTIONALITY
		//
		//
		
		/**
		 * <p>
		 * Initialise the Branch SDK.
		 * </p>
		 * <p>
		 *     Note: You should use <code>initSession( options:BranchOptions )</code>
		 *     to get access to the updated Branch features.
		 * </p>
		 *
		 * @param useTestKey Set it to <code>true</code> to use the key test.
		 */
		public function init( useTestKey:Boolean = false ):void
		{
			return initSession( new BranchOptions().setUseTestKey( useTestKey ) );
		}
		
		
		/**
		 * <p>
		 * Initialise the Branch SDK and start a session.
		 * </p>
		 *
		 * <p>
		 * You will get the deep linked params associated with the link
		 * that the user clicked before showing up via the
		 * <code>BranchEvent.INIT_SUCCESSED</code> event.
		 * </p>
		 *
		 * @example
		 *
		 * This example shows how to set the test mode and delay initialisation to check
		 * for search ads.
		 *
		 * <listing version="3.0">
		 * Branch.instance.initSession(
		 *    new BranchOptions()
		 *        .setUseTestKey()
		 *        .setDelayInitToCheckForSearchAds()
		 * );
		 * </listing>
		 *
		 * @see BranchOptions
		 */
		public function initSession( options:BranchOptions = null ):void
		{
			try
			{
				if (options == null) options = new BranchOptions();
				
				_extensionContext.call( "initSession", options );
			}
			catch (e:Error)
			{
			}
		}
		
		
		/**
		 * Often, you might have your own user IDs, or want referral and event data to persist across platforms or uninstall/reinstall.
		 * It's helpful if you know your users access your service from different devices.
		 * This where we introduce the concept of an 'identity'.
		 *
		 * @param userId Identify a user, with his user id.
		 */
		public function setIdentity( userId:String ):void
		{
			try
			{
				_extensionContext.call( "setIdentity", userId );
			}
			catch (e:Error)
			{
			}
		}
		
		
		/**
		 * If you provide a logout function in your app, be sure to clear the user when the logout completes.
		 * This will ensure that all the stored parameters get cleared and all events are properly attributed to the right identity.
		 * <b>Warning</b> this call will clear the referral credits and attribution on the device.
		 */
		public function logout():void
		{
			try
			{
				_extensionContext.call( "logout" );
			}
			catch (e:Error)
			{
			}
		}
		
		
		/**
		 * These session parameters will be available at any point later on with this command. If no params, the dictionary will be empty.
		 * This refreshes with every new session (app installs AND app opens).
		 *
		 * @return a String with sessionParams, turn it into a JSON.
		 */
		public function getLatestReferringParams():String
		{
			try
			{
				return _extensionContext.call( "getLatestReferringParams" ) as String;
			}
			catch (e:Error)
			{
			}
			return null;
		}
		
		
		/**
		 * If you ever want to access the original session params (the parameters passed in for the first install event only), you can use this line.
		 * This is useful if you only want to reward users who newly installed the app from a referral link or something.
		 *
		 * @return a String with installParams, turn it into a JSON.
		 */
		public function getFirstReferringParams():String
		{
			try
			{
				return _extensionContext.call( "getFirstReferringParams" ) as String;
			}
			catch (e:Error)
			{
			}
			return null;
		}
		
		
		/**
		 * Allows you to deep link into your own app from your app itself
		 *
		 * <p>
		 *     Warning: Handling a new deep link in your app will clear the current
		 *     session data and a new referred "open" will be attributed.
		 * </p>
		 *
		 *
		 * @param link            The deep link
		 * @param forceNewSession    If <code>true</code> a new session is created
		 */
		public function handleDeepLink( link:String, forceNewSession:Boolean = true ):void
		{
			try
			{
				_extensionContext.call( "handleDeepLink", link, forceNewSession );
			}
			catch (e:Error)
			{
			}
		}
		
		
		/**
		 * Register Custom Events
		 *
		 * @param action
		 *
		 * @param state Store some state with the event, a stringified JSON.
		 */
		public function userCompletedAction( action:String, stateStringifiedJSON:String = "{}" ):void
		{
			try
			{
				_extensionContext.call( "userCompletedAction", action, stateStringifiedJSON );
			}
			catch (e:Error)
			{
			}
		}
		
		
		/**
		 * Reward balances change randomly on the backend when certain actions are taken (defined by your rules), so it'll make an asynchronous call to retrieve the balance.
		 * Be sure to listen <code>GET_CREDITS</code> event.
		 *
		 * @param bucket The bucket to get credits balance from.
		 */
		public function getCredits( bucket:String = "" ):void
		{
			try
			{
				_extensionContext.call( "getCredits", bucket );
			}
			catch (e:Error)
			{
			}
		}
		
		
		/**
		 * We will store how many of the rewards have been deployed so that you don't have to track it on your end. In order to save that you gave the credits to the user, you can call redeem.
		 * Redemptions will reduce the balance of outstanding credits permanently.
		 *
		 * @param credits credits given to the user.
		 * @param bucket The bucket to get credits balance from.
		 */
		public function redeemRewards( credits:int, bucket:String = "" ):void
		{
			try
			{
				_extensionContext.call( "redeemRewards", credits, bucket );
			}
			catch (e:Error)
			{
			}
		}
		
		
		/**
		 * This call will retrieve the entire history of credits and redemptions from the individual user.
		 * Be sure to listen <code>GET_CREDITS_HISTORY_SUCCESSED</code> and <code>GET_CREDITS_HISTORY_FAILED</code> events.
		 *
		 * @param bucket The bucket to get credits balance from.
		 */
		public function getCreditsHistory( bucket:String = "" ):void
		{
			try
			{
				_extensionContext.call( "getCreditsHistory", bucket );
			}
			catch (e:Error)
			{
			}
		}
		
		
		//
		//
		//	TRACKING
		//
		//
		
		/**
		 * <p>
		 * Logs an event to Branch for tracking and analytics
		 * </p>
		 *
		 * <p>
		 * You should use a <code>BranchEventBuilder</code> to construct the parameter for this function.
		 * </p>
		 *
		 * @param event    An object representing the Branch event
		 *
		 * @example
		 *
		 * To log a standard event:
		 *
		 * <listing version="3.0">
		 * Branch.instance.logEvent(
		 *    new BranchEventBuilder( BranchEventBuilder.STANDARD_EVENT_PURCHASE )
		 *        .setCurrency( "USD" )
		 *        .setRevenue( 1.23 )
		 *        .build()
		 * );
		 * </listing>
		 *
		 *
		 * @example
		 *
		 * To log a custom event <code>"your_custom_event"</code>:
		 *
		 * <listing version="3.0">
		 * Branch.instance.logEvent(
		 *    new BranchEventBuilder( "your_custom_event" )
		 *        .addCustomDataProperty("your_custom_key", "your_custom_value")
		 *        .build()
		 * );
		 * </listing>
		 *
		 * @return <code>true</code> if the event is logged to Branch
		 *
		 * @see io.branch.nativeExtensions.branch.tracking.BranchEventBuilder
		 */
		public function logEvent( event:Object ):Boolean
		{
			try
			{
				return _extensionContext.call( "logEvent", JSON.stringify( event ) );
			}
			catch (e:Error)
			{
			}
			return false;
		}
		
		
		//
		//
		//	LEGACY
		//
		//
		
		
		/**
		 * With each Branch link, we pack in as much functionality and measurement as possible.
		 * You get the powerful deep linking functionality in addition to the all the install and reengagement attribution, all in one link.
		 * For more details on how to create links, see the <a href="https://github.com/BranchMetrics/Branch-Integration-Guides/blob/master/url-creation-guide.md">Branch link creation guide</a>.
		 *
		 * @param tags examples: set of tags could be "version1", "trial6", etc; each tag should not exceed 64 characters
		 * @param channel examples: "facebook", "twitter", "text_message", etc; should not exceed 128 characters
		 * @param feature examples: Branch.FEATURE_TAG_SHARE, Branch.FEATURE_TAG_REFERRAL, "unlock", etc; should not exceed 128 characters
		 * @param stage examples: "past_customer", "logged_in", "level_6"; should not exceed 128 characters
		 * @param json a stringify JSON, you can access this data from any instance that installs or opens the app from this link, customize the display of the Branch link and customize the desktop redirect location
		 * @param alias the alias for a link.
		 * @param type can be used for scenarios where you want the link to only deep link the first time.
		 */
		public function getShortUrl( tags:Array = null, channel:String = "", feature:String = "", stage:String = "", json:String = "{}", alias:String = "", type:int = -1 ):void
		{
			try
			{
				_extensionContext.call( "getShortUrl", tags, channel, feature, stage, json, alias, type );
			}
			catch (e:Error)
			{
			}
		}
		
		
		
		
		//
		//	DEBUG
		//
		
		/**
		 * <p>
		 * This will attempt to validate the current application's Branch integration
		 * and will output results to the device log
		 * </p>
		 * <p>
		 * This is for testing in development only! Make sure you remove or comment out this line of code in your release versions.
		 * </p>
		 *
		 *
		 *
		 */
		public function validateIntegration():void
		{
			try
			{
				_extensionContext.call( "validateIntegration" );
			}
			catch (e:Error)
			{
			}
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		private function extension_statusHandler( event:StatusEvent ):void
		{
			var data:Object;
			try
			{
				switch (event.code)
				{
					case BranchCreditsEvent.GET_CREDITS_SUCCESS:
					case BranchCreditsEvent.GET_CREDITS_FAILED:
					case BranchCreditsEvent.GET_CREDITS_HISTORY_SUCCESS:
					case BranchCreditsEvent.GET_CREDITS_HISTORY_FAILED:
					case BranchCreditsEvent.REDEEM_REWARDS_SUCCESS:
					case BranchCreditsEvent.REDEEM_REWARDS_FAILED:
					{
						dispatchEvent( new BranchCreditsEvent( event.code, event.level ) );
						break;
					}
					
					case BranchEvent.INIT_SUCCESS:
					case BranchEvent.GET_SHORT_URL_SUCCESS:
					case BranchEvent.SET_IDENTITY_SUCCESS:
					case BranchEvent.INIT_FAILED:
					case BranchEvent.GET_SHORT_URL_FAILED:
					case BranchEvent.SET_IDENTITY_FAILED:
					default:
					{
						dispatchEvent( new BranchEvent( event.code, event.level ) );
						break;
					}
				}
			}
			catch (e:Error)
			{
			}
		}
		
		
		private function nativeApplication_invokeHandler( event:InvokeEvent ):void
		{
			try
			{
				_extensionContext.call( "invoke" );
			}
			catch (e:Error)
			{
			}
		}
		
		
		
		
		
		
		//
		//
		// DEPRECATIONS
		//
		//
		
		
		[Deprecated(message="This referral functionality has been removed from the Branch SDK")]
		/**
		 * Retrieve the referral code created by current user.
		 * Be sure to listen <code>GET_REFERRAL_CODE_SUCCESSED</code> and <code>GET_REFERRAL_CODE_FAILED</code> events.
		 */
		public function getReferralCode():void
		{
		}
		
		
		[Deprecated(message="This referral functionality has been removed from the Branch SDK")]
		/**
		 * Create a new referral code for the current user, only if this user doesn't have any existing non-expired referral code.
		 * Be sure to listen <code>CREATE_REFERRAL_CODE_SUCCESSED</code> and <code>CREATE_REFERRAL_CODE_FAILED</code> events.
		 *
		 * @param prefix The prefix to the referral code that you desire.
		 * @param amount The amount of credit to redeem when user applies the referral code.
		 * @param expiration The expiration date of the referral code, a number of milliseconds since midnight January 1, 1970, universal time.
		 * @param bucket The name of the bucket to use.
		 * @param calculationType This defines whether the referral code can be applied indefinitely, or only once per user. Check <code>BranchConst.REFERRAL_CODE_AWARD_UNLIMITED</code>: referral code can be applied continually and <code>BranchConst.REFERRAL_CODE_AWARD_UNIQUE</code>: a user can only apply a specific referral code once.
		 * @param location The user to reward for applying the referral code. Check <code>BranchConst.REFERRAL_CODE_LOCATION_REFERREE</code>: the user applying the referral code receives credit, <code>BranchConst.REFERRAL_CODE_LOCATION_REFERRING_USER</code>: the user who created the referral code receives credit and <code>BranchConst.REFERRAL_CODE_LOCATION_BOTH</code>: both the creator and applicant receive credit.
		 */
		public function createReferralCode( prefix:String, amount:int, expiration:int, bucket:String, calculationType:int, location:int ):void
		{
		}
		
		
		[Deprecated(message="This referral functionality has been removed from the Branch SDK")]
		/**
		 * Validate if a referral code exists in Branch system and is still valid. A code is vaild if:
		 * <ul><li>It hasn't expired.</li>
		 * <li>If its calculation type is uniqe, it hasn't been applied by current user.</li></ul>
		 * Be sure to listen <code>VALIDATE_REFERRAL_CODE_SUCCESSED</code> and <code>VALIDATE_REFERRAL_CODE_FAILED</code> events.
		 * @param code The referral code to validate.
		 */
		public function validateReferralCode( code:String ):void
		{
		}
		
		
		[Deprecated(message="This referral functionality has been removed from the Branch SDK")]
		/**
		 * Apply a referral code if it exists in Branch system and is still valid.
		 * Be sure to listen <code>APPLY_REFERRAL_CODE_SUCCESSED</code> and <code>APPLY_REFERRAL_CODE_FAILED</code> events.
		 * @param code The referral code to apply.
		 */
		public function applyReferralCode( code:String ):void
		{
		}
		
		
		
		
		
	}
	
}
