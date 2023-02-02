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
package io.branch.nativeExtensions.branch
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	import io.branch.nativeExtensions.branch.buo.BranchUniversalObject;
	import io.branch.nativeExtensions.branch.buo.ContentMetadata;
	import io.branch.nativeExtensions.branch.buo.LinkProperties;
	import io.branch.nativeExtensions.branch.events.BranchUniversalObjectEvent;
	
	
	internal class _BranchUniversalObject extends EventDispatcher implements BranchUniversalObject
	{
		////////////////////////////////////////////////////////
		//  CONSTANTS
		//
		
		private static const TAG:String = "_BranchUniversalObject";
		
		
		////////////////////////////////////////////////////////
		//  VARIABLES
		//
		
		private var _extContext:ExtensionContext;
		
		private var _generateShortUrlCallbacks:Object = {};
		
		private var _identifier:String;
		
		private var _properties:Object;
		
		
		////////////////////////////////////////////////////////
		//  FUNCTIONALITY
		//
		
		public function _BranchUniversalObject( extContext:ExtensionContext )
		{
			_extContext = extContext;
			_identifier = generateIdentifier();
			_properties = {};
		}
		
		
		//
		//	PROPERTIES
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function setCanonicalIdentifier( identifier:String ):BranchUniversalObject
		{
			_properties[ "canonicalIdentifier" ] = identifier;
			return this;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function setCanonicalUrl( canonicalUrl:String ):BranchUniversalObject
		{
			_properties[ "canonicalUrl" ] = canonicalUrl;
			return this;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function setTitle( title:String ):BranchUniversalObject
		{
			_properties[ "title" ] = title;
			return this;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function setContentDescription( contentDescription:String ):BranchUniversalObject
		{
			_properties[ "contentDescription" ] = contentDescription;
			return this;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function setContentImageUrl( contentImageUrl:String ):BranchUniversalObject
		{
			_properties[ "contentImageUrl" ] = contentImageUrl;
			return this;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function setContentIndexingMode( contentIndexingMode:String ):BranchUniversalObject
		{
			_properties[ "contentIndexingMode" ] = contentIndexingMode;
			return this;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function setLocalIndexMode( localIndexMode:String ):BranchUniversalObject
		{
			_properties[ "localIndexMode" ] = localIndexMode;
			return this;
		}
		
		
		public function setContentMetadata( metadata:ContentMetadata ):BranchUniversalObject
		{
			_properties[ "metadata" ] = metadata.toObject();
			return this;
		}
		
		
		//
		//	FUNCTIONS
		//
		
		
		/**
		 * @inheritDoc
		 */
		public function generateShortUrl( properties:LinkProperties, callback:Function = null ):void
		{
			var requestId:String = generateIdentifier();
			try
			{
				if (callback != null)
				{
					_generateShortUrlCallbacks[ requestId ] = callback;
				}
				if (properties == null)
				{
					properties = new LinkProperties();
				}
				
				_extContext.addEventListener( StatusEvent.STATUS, extContext_statusHander );
				_extContext.call( "buo_generateShortUrl",
								  requestId,
								  JSON.stringify( this.toObject() ),
								  JSON.stringify( properties.toObject() )
				);
			}
			catch (e:Error)
			{
				trace( e );
			}
//			return requestId;
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function userCompletedAction( event:String ):void
		{
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLING
		//
		
		override public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			super.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		
		override public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void
		{
			super.removeEventListener( type, listener, useCapture );
		}
		
		
		////////////////////////////////////////////////////////
		//	INTERNALS
		//
		
		
		private function toObject():Object
		{
			var o:Object = {};
			o.identifier = _identifier;
			o.properties = _properties;
			return o;
		}
		
		
		private function generateIdentifier():String
		{
			var uid:Array = [];
			var chars:Array = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70];
			var separator:uint = 45;
			var template:Array = [8, 4, 4, 4, 12];
			for (var a:uint = 0; a < template.length; a++)
			{
				for (var b:uint = 0; b < template[ a ]; b++)
				{
					uid.push( chars[ Math.floor( Math.random() * chars.length ) ] );
				}
				if (a < template.length - 1)
				{
					uid.push( separator );
				}
			}
			return String.fromCharCode.apply( null, uid );
		}
		
		
		////////////////////////////////////////////////////////
		//  EVENT HANDLERS
		//
		
		private function extContext_statusHander( event:StatusEvent ):void
		{
			var data:Object;
			try
			{
				data = JSON.parse( event.level );
				if (data.hasOwnProperty( "identifier" ) && data.identifier == _identifier)
				{
					switch (event.code)
					{
						case BranchUniversalObjectEvent.GENERATE_SHORT_URL_SUCCESS:
						case BranchUniversalObjectEvent.GENERATE_SHORT_URL_FAILED:
						{
							var requestId:String = (data.hasOwnProperty( "requestId" ) ? data.requestId : "");
							var url:String = data.url;
							var error:BranchError = BranchError.fromObject( data.error );
							
							if (_generateShortUrlCallbacks.hasOwnProperty( requestId ))
							{
								var callback:Function = _generateShortUrlCallbacks[ requestId ];
								callback( url, error );
								delete _generateShortUrlCallbacks[ requestId ];
							}
							
							dispatchEvent( new BranchUniversalObjectEvent(
									event.code,
									url,
									error
							) );
							
							break;
							
						}
					}
				}
			}
			catch (e:Error)
			{
			}
		}
		
		
	}
	
}
