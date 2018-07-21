package io.branch.nativeExtensions.branch
{
	
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;
	
	
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
		
		
		public function setIdentity( userId:String ):void
		{
		}
		
		
		public function getShortUrl( tags:Array = null, channel:String = "", feature:String = "", stage:String = "", json:String = "{}", alias:String = "", type:int = -1 ):void
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
		
		
		public function getReferralCode():void
		{
		}
		
		
		public function createReferralCode( prefix:String, amount:int, expiration:int, bucket:String, calculationType:int, location:int ):void
		{
		}
		
		
		public function validateReferralCode( code:String ):void
		{
		}
		
		
		public function applyReferralCode( code:String ):void
		{
		}
		
	}
	
}
