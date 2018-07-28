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
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @created		08/01/2016
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.branch
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import io.branch.nativeExtensions.branch.Branch;
	import io.branch.nativeExtensions.branch.BranchConst;
	import io.branch.nativeExtensions.branch.events.BranchEvent;
	import io.branch.nativeExtensions.branch.tracking.BranchEventBuilder;
	
	import starling.core.Starling;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	/**
	 */
	public class BranchTests extends Sprite
	{
		public static const TAG:String = "";
		
		private var _l:ILogger;
		
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function BranchTests( logger:ILogger )
		{
			_l = logger;
			try
			{
				log( "Branch Supported: " + Branch.isSupported );
				if (Branch.isSupported)
				{
					log( "Branch Version:   " + Branch.instance.version );
					
					NativeApplication.nativeApplication.addEventListener( InvokeEvent.INVOKE, invokeHandler );
					
					Branch.instance.addEventListener( BranchEvent.SET_IDENTITY_FAILED, branch_genericHandler );
					Branch.instance.addEventListener( BranchEvent.SET_IDENTITY_SUCCESSED, branch_genericHandler );
					
					
					Branch.instance.addEventListener( BranchEvent.GET_CREDITS_FAILED, branch_genericHandler );
					Branch.instance.addEventListener( BranchEvent.GET_CREDITS_SUCCESSED, branch_genericHandler );
					
					Branch.instance.addEventListener( BranchEvent.REDEEM_REWARDS_FAILED, branch_genericHandler );
					Branch.instance.addEventListener( BranchEvent.REDEEM_REWARDS_SUCCESSED, branch_genericHandler );
					
					Branch.instance.addEventListener( BranchEvent.GET_CREDITS_HISTORY_FAILED, branch_genericHandler );
					Branch.instance.addEventListener( BranchEvent.GET_CREDITS_HISTORY_SUCCESSED, branch_genericHandler );
					
				}
				
			}
			catch (e:Error)
			{
				log( e.message );
			}
		}
		
		
		////////////////////////////////////////////////////////
		//  
		//
		
		public function init():void
		{
			log( "init()" );
			if (Branch.isSupported)
			{
				Branch.instance.addEventListener( BranchEvent.INIT_FAILED, init_failedHandler );
				Branch.instance.addEventListener( BranchEvent.INIT_SUCCESSED, init_successHandler );
				
				Branch.instance.init( true );
			}
		}
		
		private function init_successHandler( event:BranchEvent ):void
		{
			log( event.type + "::" + event.informations );
			
			Branch.instance.removeEventListener( BranchEvent.INIT_FAILED, init_failedHandler );
			Branch.instance.removeEventListener( BranchEvent.INIT_SUCCESSED, init_successHandler );
			
			// params are the deep linked params associated with the link that the user clicked before showing up
			// params will be empty if no data found
			
			Branch.instance.setIdentity( "Bob" );
			
//			Branch.instance.getCredits();
//			Branch.instance.getCreditsHistory();
			
			var sessionParams:String = Branch.instance.getLatestReferringParams();
			log( "sessionParams: " + sessionParams );
			
			var installParams:String = Branch.instance.getFirstReferringParams();
			log( "installParams: " + installParams );
		}
		
		
		private function init_failedHandler( event:BranchEvent ):void
		{
			log( event.type + "::" + event.informations );
			
			Branch.instance.removeEventListener( BranchEvent.INIT_FAILED, init_failedHandler );
			Branch.instance.removeEventListener( BranchEvent.INIT_SUCCESSED, init_successHandler );
		}
		
		
		
		//
		//	INVOKE
		//
		
		private function invokeHandler( event:InvokeEvent ):void
		{
			log( "invoke" );
			
			var sessionParams:String = Branch.instance.getLatestReferringParams();
			log( "sessionParams: " + sessionParams );
		}
		
		
		
		//
		//	TRACKING
		//
		
		public function trackStandard():void
		{
			log( "trackStandard()" );
			Branch.instance.logEvent(
					new BranchEventBuilder( BranchEventBuilder.STANDARD_EVENT_PURCHASE )
							.setRevenue( 1.23 )
							.setTax( 0.12 )
							.setTransactionID( "XXDDCCFFDD" )
							.setCurrency("USD")
							.setShipping(0)
							.build()
			);
		}
		
		
		
		public function trackCustom():void
		{
			log( "trackCustom()" );
			Branch.instance.logEvent(
					new BranchEventBuilder( "your_custom_event" )
							.addCustomDataProperty("your_custom_key", "your_custom_value")
							.build()
			);
		}
		
		
		
		
		
		//
		//	SHORT URL
		//
		
		public function getShortUrl():void
		{
			log( "getShortUrl()" );
			
			var dataToInclude:Object = {
				user:        "Joe",
				profile_pic: "https://avatars3.githubusercontent.com/u/7772941?v=3&s=200",
				description: "Joe likes long walks on the beach...",
				
				// customize the display of the Branch link
				"$og_title":       "Joe's My App Referral",
				"$og_image_url":   "https://branch.io/img/logo_white.png",
				"$og_description": "Join Joe in My App - it's awesome"
			};
			
			var tags:Array = [ "version1", "trial6" ];
			
			
			Branch.instance.addEventListener( BranchEvent.GET_SHORT_URL_FAILED, getShortUrl_failedHandler );
			Branch.instance.addEventListener( BranchEvent.GET_SHORT_URL_SUCCESSED, getShortUrl_successHandler );
			
			Branch.instance.getShortUrl(
					tags,
					"text_message",
					BranchConst.FEATURE_TAG_SHARE,
					"level_3",
					JSON.stringify(dataToInclude)
			);

		}
		
		
		private function getShortUrl_failedHandler( event:BranchEvent ):void
		{
			log( event.type + "::" + event.informations );
			
			Branch.instance.removeEventListener( BranchEvent.GET_SHORT_URL_FAILED, getShortUrl_failedHandler );
			Branch.instance.removeEventListener( BranchEvent.GET_SHORT_URL_SUCCESSED, getShortUrl_successHandler );
		}
		
		
		private function getShortUrl_successHandler( event:BranchEvent ):void
		{
			log( event.type + "::" + event.informations );
			
			Branch.instance.removeEventListener( BranchEvent.GET_SHORT_URL_FAILED, getShortUrl_failedHandler );
			Branch.instance.removeEventListener( BranchEvent.GET_SHORT_URL_SUCCESSED, getShortUrl_successHandler );
		

			Branch.instance.handleDeepLink( event.informations );
		
		}
		
		
		
		
		
		
		
		
		
		
		private function branch_genericHandler( event:BranchEvent ):void
		{
			log( event.type + "::"+ event.informations );
			
			if (event.type == BranchEvent.GET_CREDITS_SUCCESSED)
				Branch.instance.redeemRewards( 5 );
		}
		
		
	}
}
