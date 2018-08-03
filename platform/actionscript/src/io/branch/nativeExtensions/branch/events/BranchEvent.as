package io.branch.nativeExtensions.branch.events
{
	import flash.events.Event;
	
	
	public class BranchEvent extends Event
	{
		////////////////////////////////////////////////////////
		//  CONSTANTS
		//
		
		/**
		 * Dispatched when the key has been successfully set up. See event's <code>data</code> for referringParams.
		 *
		 * @eventType init:success
		 */
		public static const INIT_SUCCESS:String = "init:success";
		
		/**
		 * Dispatched when the key init has failed. See event's <code>data</code> for details.
		 *
		 * @eventType init:failed
		 */
		public static const INIT_FAILED:String = "init:failed";
		
		
		/**
		 * Dispatched when the identity has been successfully set up.
		 *
		 * @eventType setidentity:success
		 */
		public static const SET_IDENTITY_SUCCESS:String = "setidentity:success";
		
		/**
		 * Dispatched when the identity set up has failed. See event's <code>data</code> for details.
		 *
		 * @eventType setidentity:failed
		 */
		public static const SET_IDENTITY_FAILED:String = "setidentity:failed";
		
		
		/**
		 * Dispatched when the short url has been successfully created. See event's <code>data</code> for the result.
		 *
		 * @eventType getshorturl:success
		 */
		public static const GET_SHORT_URL_SUCCESS:String = "getshorturl:success";
		
		/**
		 * Dispatched when the <code>getShortUrl</code> has failed. See event's <code>data</code> for details.
		 *
		 * @eventType getshorturl:failed
		 */
		public static const GET_SHORT_URL_FAILED:String = "getshorturl:failed";
		
		
		
		
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
		 * </p>
		 */
		public var data:String;
		
		
		////////////////////////////////////////////////////////
		//  FUNCTIONALITY
		//
		
		public function BranchEvent( type:String, data:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
			this.data = data;
		}
		
		
		override public function clone():Event
		{
			return new BranchEvent( type, data, bubbles, cancelable );
		}
		
		
	}
	
}