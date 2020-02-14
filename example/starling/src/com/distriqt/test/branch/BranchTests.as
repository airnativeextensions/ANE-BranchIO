package com.distriqt.test.branch
{
	import com.distriqt.extension.core.Core;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import io.branch.nativeExtensions.branch.Branch;
	import io.branch.nativeExtensions.branch.BranchConst;
	import io.branch.nativeExtensions.branch.BranchOptions;
	import io.branch.nativeExtensions.branch.events.BranchCreditsEvent;
	import io.branch.nativeExtensions.branch.events.BranchEvent;
	import io.branch.nativeExtensions.branch.tracking.BranchEventBuilder;
	
	import starling.core.Starling;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	
	/**
	 * This class demonstrates Branch functionality in small test cases
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
				Core.init();
				log( "Branch Supported: " + Branch.isSupported );
				if (Branch.isSupported)
				{
					log( "Branch Version:   " + Branch.instance.version );
//					NativeApplication.nativeApplication.addEventListener( InvokeEvent.INVOKE, invokeHandler );
					
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
		
		public function initSession():void
		{
			log( "initSession()" );
			if (Branch.isSupported)
			{
				Branch.instance.addEventListener( BranchEvent.INIT_FAILED, init_failedHandler );
				Branch.instance.addEventListener( BranchEvent.INIT_SUCCESS, init_successHandler );
				
				Branch.instance.initSession(
						new BranchOptions()
								.setDebugMode()
//								.setUseTestKey()
//								.setDelayInitToCheckForSearchAds()
				);
			}
		}
		
		
		private function getPropertyFromParams( params:Object, propertyName:String, defaultValue:* ):*
		{
			if (params.hasOwnProperty(propertyName))
				return params[propertyName];
			return defaultValue;
		}
		
		
		private function init_successHandler( event:BranchEvent ):void
		{
			log( event.type + "::" + event.data );
			
			// params are the deep linked params associated with the link that the user clicked before showing up
			// params will be empty if no data found
			
			try
			{
				var sessionParams:Object = JSON.parse(event.data);
				
				var clicked_branch_link:Boolean = getPropertyFromParams( sessionParams, "+clicked_branch_link", false );
				var match_guaranteed:Boolean = getPropertyFromParams( sessionParams, "+match_guaranteed", false );
				
				if (clicked_branch_link && match_guaranteed)
				{
					log( "CLICKED BRANCH LINK" );
				}
			}
			catch (e:Error)
			{
			}
			

//			var sessionParamsString:String = Branch.instance.getLatestReferringParams();
//			log( "sessionParams: " + sessionParamsString );

//			var installParams:String = Branch.instance.getFirstReferringParams();
//			log( "installParams: " + installParams );
			
			
//			Branch.instance.setIdentity( "Bob" );
		
		
		
		
		}
		
		
		private function init_failedHandler( event:BranchEvent ):void
		{
			log( event.type + "::" + event.data );
		}
		
		
		//
		//	INVOKE
		//
		
		private function invokeHandler( event:InvokeEvent ):void
		{
			log( "invoke: " + event.arguments.join(",") );
			var sessionParams:String = Branch.instance.getLatestReferringParams();
			log( "sessionParams: " + sessionParams );
		}
		
		public function getLatestReferringParams():void
		{
			log( "getLatestReferringParams:" + Branch.instance.getLatestReferringParams() );
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
							.setCurrency( "USD" )
							.setShipping( 0 )
							.build()
			);
		}
		
		
		public function trackCustom():void
		{
			log( "trackCustom()" );
			Branch.instance.logEvent(
					new BranchEventBuilder( "your_custom_event" )
							.addCustomDataProperty( "your_custom_key", "your_custom_value" )
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
			Branch.instance.addEventListener( BranchEvent.GET_SHORT_URL_SUCCESS, getShortUrl_successHandler );
			
			Branch.instance.getShortUrl(
					tags,
					"text_message",
					BranchConst.FEATURE_TAG_SHARE,
					"level_3",
					JSON.stringify( dataToInclude )
			);
			
		}
		
		
		private function getShortUrl_failedHandler( event:BranchEvent ):void
		{
			log( event.type + "::" + event.data );
			
			Branch.instance.removeEventListener( BranchEvent.GET_SHORT_URL_FAILED, getShortUrl_failedHandler );
			Branch.instance.removeEventListener( BranchEvent.GET_SHORT_URL_SUCCESS, getShortUrl_successHandler );
		}
		
		
		private function getShortUrl_successHandler( event:BranchEvent ):void
		{
			log( event.type + "::" + event.data );
			
			Branch.instance.removeEventListener( BranchEvent.GET_SHORT_URL_FAILED, getShortUrl_failedHandler );
			Branch.instance.removeEventListener( BranchEvent.GET_SHORT_URL_SUCCESS, getShortUrl_successHandler );
			
			
			Branch.instance.handleDeepLink( event.data );
			
		}
		
		
		//
		//	SET IDENTITY
		//
		
		public function setIdentity():void
		{
			log( "setIdentity()" );
			
			var userId:String = "user" + int( Math.random() * 100000 );
			
			Branch.instance.addEventListener( BranchEvent.SET_IDENTITY_FAILED, setIdentityHandler );
			Branch.instance.addEventListener( BranchEvent.SET_IDENTITY_SUCCESS, setIdentityHandler );
			
			Branch.instance.setIdentity( userId );
		}
		
		
		private function setIdentityHandler( event:BranchEvent ):void
		{
			log( event.type + "::" + event.data );
			
			Branch.instance.removeEventListener( BranchEvent.SET_IDENTITY_FAILED, setIdentityHandler );
			Branch.instance.removeEventListener( BranchEvent.SET_IDENTITY_SUCCESS, setIdentityHandler );
		}
		
		
		
		//
		//	DEBUG
		//
		
		public function validateIntegration():void
		{
			Branch.instance.validateIntegration();
		}
		
		
		
	}
	
}
