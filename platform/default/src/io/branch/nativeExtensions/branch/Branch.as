package io.branch.nativeExtensions.branch
{
	
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;
	
	
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
	
	
	
	public class Branch extends EventDispatcher
	{
		////////////////////////////////////////////////////////
		//	CONSTANTS
		//
		
		public static const EXT_CONTEXT_ID:String = Const.EXTENSIONID;
		
		public static const VERSION:String = Const.VERSION;
		
		private static const ERROR_CREATION:String = "The native extension context could not be created";
		private static const ERROR_SINGLETON:String = "The singleton has already been created. Use Branch.instance to access the functionality";
		
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		private static var _instance:Branch;
		private static var _shouldCreateInstance:Boolean = false;
		
		
		
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
		
		public function Branch()
		{
			if (_shouldCreateInstance)
			{
			}
			else
			{
				throw new Error( ERROR_SINGLETON );
			}
		}
		
		
		public function init( useTestKey:Boolean = false ):void
		{
		}
		
		
		public function initSession( options:BranchOptions=null ):void
		{
		}
		
		
		public function setIdentity( userId:String ):void
		{
		}
		
		
		public function logout():void
		{
		}
		
		
		
		public function getLatestReferringParams():String
		{
			return "";
		}
		
		
		public function getFirstReferringParams():String
		{
			return "";
		}
		
		
		public function userCompletedAction( action:String, stateStringifiedJSON:String = "{}" ):void
		{
		}
		
		
		public function getCredits( bucket:String = "" ):void
		{
		}
		
		
		public function redeemRewards( credits:int, bucket:String = "" ):void
		{
		}
		
		
		public function getCreditsHistory( bucket:String = "" ):void
		{
		}
		
		
		
		public function handleDeepLink( link:String, forceNewSession:Boolean=true ):void
		{
		}
		
		//
		//	TRACKING
		//
		
		public function logEvent( event:Object ):Boolean
		{
			return false;
		}
		
		
		
		//
		//
		//	LEGACY
		//
		//
		
		public function getShortUrl( tags:Array = null, channel:String = "", feature:String = "", stage:String = "", json:String = "{}", alias:String = "", type:int = -1 ):void
		{
		}
		
		
		
		
		//
		//
		//	DEPRECATED
		//
		//
		
		
		
		[Deprecated(message="This referral functionality has been removed from the Branch SDK")]
		public function getReferralCode():void
		{
		}
		
		
		[Deprecated(message="This referral functionality has been removed from the Branch SDK")]
		public function createReferralCode( prefix:String, amount:int, expiration:int, bucket:String, calculationType:int, location:int ):void
		{
		}
		
		
		[Deprecated(message="This referral functionality has been removed from the Branch SDK")]
		public function validateReferralCode( code:String ):void
		{
		}
		
		
		[Deprecated(message="This referral functionality has been removed from the Branch SDK")]
		public function applyReferralCode( code:String ):void
		{
		}
		
		
		
	}
	
}
