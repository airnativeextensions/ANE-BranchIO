/**
 *        __       __               __
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / /
 * \__,_/_/____/_/ /_/  /_/\__, /_/
 *                           / /
 *                           \/
 * http://distriqt.com
 *
 * @brief
 * @author 		Michael Archbold (https://github.com/marchbold)
 * @created		3/8/18
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.events
{
	import flash.events.Event;
	
	
	/**
	 * This Event contains information about credit related calls
	 */
	public class BranchCreditsEvent extends Event
	{
		////////////////////////////////////////////////////////
		//  CONSTANTS
		//
		
		private static const TAG:String = "BranchCreditsEvent";
		
		
		//
		//	CREDITS EVENTS
		//
		
		/**
		 * Dispatched when the <code>getCredits</code> method is called and SUCCESS. See event's <code>data</code> for details.
		 *
		 * @eventType getcredits:success
		 */
		public static const GET_CREDITS_SUCCESS:String = "getcredits:success";
		
		/**
		 * Dispatched when the <code>getCredits</code> has failed. See event's <code>data</code> for details.
		 *
		 * @eventType getcredits:failed
		 */
		public static const GET_CREDITS_FAILED:String = "getcredits:failed";
		
		
		/**
		 * Dispatched when the <code>redeemRewards</code> has SUCCESS.
		 *
		 * @eventType redeemrewards:success
		 */
		public static const REDEEM_REWARDS_SUCCESS:String = "redeemrewards:success";
		
		/**
		 * Dispatched when the <code>redeemRewards</code> has failed. See event's <code>data</code> for details.
		 *
		 * @eventType redeemrewards:failed
		 */
		public static const REDEEM_REWARDS_FAILED:String = "redeemrewards:failed";
		
		
		/**
		 * Dispatched when the <code>getCreditsHistory</code> method is called and SUCCESS. See event's <code>data</code> for details.
		 *
		 * @eventType getcreditshistory:success
		 */
		public static const GET_CREDITS_HISTORY_SUCCESS:String = "getcreditshistory:success";
		
		/**
		 * Dispatched when the <code>getCreditsHistory</code> has failed. See event's <code>data</code> for details.
		 *
		 * @eventType getcreditshistory:failed
		 */
		public static const GET_CREDITS_HISTORY_FAILED:String = "getcreditshistory:failed";
		
		
		////////////////////////////////////////////////////////
		//  VARIABLES
		//
		
		/**
		 * <p>
		 * For failed events <code>data</code> contains an error message describing the error that occurred.
		 * </p>
		 *
		 * <p>
		 * For success events generally this consists of a JSON object that can be converted using <code>JSON.parse( event.data );</code>
		 * It can also contains credits, think to turn them into <code>int</code>!
		 * And also the credits history as a stringified array!
		 * </p>
		 */
		public var data:String;
		
		
		////////////////////////////////////////////////////////
		//  FUNCTIONALITY
		//
		
		public function BranchCreditsEvent( type:String, data:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
			this.data = data;
		}
		
		
		override public function clone():Event
		{
			return new BranchCreditsEvent( type, data, bubbles, cancelable );
		}
		
		
	}
	
}
