/**
 *        __       __               __
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / /
 * \__,_/_/____/_/ /_/  /_/\__, /_/
 *                           / /
 *                           \/
 * https://distriqt.com
 *
 * @brief
 * @author 		Michael Archbold (https://github.com/marchbold)
 * @created		19/9/20
 * @copyright	https://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.events
{
	import flash.events.Event;
	
	import io.branch.nativeExtensions.branch.BranchError;
	
	
	public class BranchUniversalObjectEvent extends Event
	{
		
		////////////////////////////////////////////////////////
		//  CONSTANTS
		//
		
		/**
		 * Dispatched when the short url has been successfully created.
		 *
		 * @eventType generateShortUrl:success
		 */
		public static const GENERATE_SHORT_URL_SUCCESS:String = "generateShortUrl:success";
		
		/**
		 * Dispatched when the <code>generateShortUrl</code> has failed.
		 *
		 * @eventType generateShortUrl:failed
		 */
		public static const GENERATE_SHORT_URL_FAILED:String = "generateShortUrl:failed";
		
		
		////////////////////////////////////////////////////////
		//  VARIABLES
		//
		
		/**
		 * TODO
		 */
		public var url:String;
		
		
		/**
		 * TODO
		 */
		public var error:BranchError;
		
		
		////////////////////////////////////////////////////////
		//  FUNCTIONALITY
		//
		
		
		public function BranchUniversalObjectEvent( type:String, url:String, error:BranchError, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
			this.url = url;
			this.error = error;
		}
		
		
		override public function clone():Event
		{
			return new BranchUniversalObjectEvent( type, url, error, bubbles, cancelable );
		}
		
		
	}
	
}
