package io.branch.nativeExtensions.branch.events
{
	import flash.events.Event;

	
	public class BranchEvent extends Event
	{
		////////////////////////////////////////////////////////
		//  CONSTANTS
		//
		
		/**
		 * Dispatched when the key has been succesfully set up. See event's <code>informations</code> for referringParams.
		 */
		public static const INIT_SUCCESSED:String = "INIT_SUCCESSED";
		
		/**
		 * Dispatched when the key init has failed. See event's <code>informations</code> for details.
		 */
		public static const INIT_FAILED:String = "INIT_FAILED";
		
		
		
		/**
		 * Dispatched when the identity has been succesfully set up.
		 */
		public static const SET_IDENTITY_SUCCESSED:String = "SET_IDENTITY_SUCCESSED";
		
		/**
		 * Dispatched when the identity set up has failed. See event's <code>informations</code> for details.
		 */
		public static const SET_IDENTITY_FAILED:String = "SET_IDENTITY_FAILED";
		
		
		
		/**
		 * Dispatched when the short url has been succesfully created. See event's <code>informations</code> for the result.
		 */
		public static const GET_SHORT_URL_SUCCESSED:String = "GET_SHORT_URL_SUCCESSED";
		
		/**
		 * Dispatched when the <code>getShortUrl</code> has failed. See event's <code>informations</code> for details.
		 */
		public static const GET_SHORT_URL_FAILED:String = "GET_SHORT_URL_FAILED";
		
		
		
		/**
		 * Dispatched when the <code>getCredits</code> method is called and successed. See event's <code>informations</code> for details.
		 */
		public static const GET_CREDITS_SUCCESSED:String = "GET_CREDITS_SUCCESSED";
		
		/**
		 * Dispatched when the <code>getCredits</code> has failed. See event's <code>informations</code> for details.
		 */
		public static const GET_CREDITS_FAILED:String = "GET_CREDITS_FAILED";
		
		
		
		/**
		 * Dispatched when the <code>redeemRewards</code> has successed.
		 */
		public static const REDEEM_REWARDS_SUCCESSED:String = "REDEEM_REWARDS_SUCCESSED";
		
		/**
		 * Dispatched when the <code>redeemRewards</code> has failed. See event's <code>informations</code> for details.
		 */
		public static const REDEEM_REWARDS_FAILED:String = "REDEEM_REWARDS_FAILED";
		
		
		
		/**
		 * Dispatched when the <code>getCreditsHistory</code> method is called and successed. See event's <code>informations</code> for details.
		 */
		public static const GET_CREDITS_HISTORY_SUCCESSED:String = "GET_CREDITS_HISTORY_SUCCESSED";
		
		/**
		 * Dispatched when the <code>getCreditsHistory</code> has failed. See event's <code>informations</code> for details.
		 */
		public static const GET_CREDITS_HISTORY_FAILED:String = "GET_CREDITS_HISTORY_FAILED";
		
		
		
		
		////////////////////////////////////////////////////////
		//  VARIABLES
		//
		
		/**
		 * <code>informations</code> contains the error from the base SDK or the the result expected like for <code>getShortUrl</code>, <code>getReferralCode</code>, <code>createReferralCode</code>.
		 * It can also contains credits, think to turn them into <code>int</code>!
		 * And also the credits history as a stringified array!
		 * Or the code referral applied as stringified JSON.
		 */
		public var informations:String;
		
		
		
		////////////////////////////////////////////////////////
		//  FUNCTIONALITY
		//
		
		public function BranchEvent( type:String, informations:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
			
			this.informations = informations;
		}
		
		
		override public function clone():Event
		{
			return new BranchEvent( type, informations, bubbles, cancelable );
		}
		
		
	}
	
}
