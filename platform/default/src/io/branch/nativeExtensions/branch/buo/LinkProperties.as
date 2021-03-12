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
 * @created		19/9/20
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.buo
{
	
	public class LinkProperties
	{
		////////////////////////////////////////////////////////
		//  CONSTANTS
		//
		
		private static const TAG:String = "LinkProperties";
		
		
		////////////////////////////////////////////////////////
		//  VARIABLES
		//
		
		
		private var _properties:Object;
		
		
		////////////////////////////////////////////////////////
		//  FUNCTIONALITY
		//
		
		public function LinkProperties()
		{
			_properties = {};
		}
		
		
		public function setChannel( channel:String ):LinkProperties
		{
			_properties[ "channel" ] = channel;
			return this;
		}
		
		
		public function setFeature( feature:String ):LinkProperties
		{
			_properties[ "feature" ] = feature;
			return this;
		}
		
		
		public function setCampaign( campaign:String ):LinkProperties
		{
			_properties[ "campaign" ] = campaign;
			return this;
		}
		
		
		public function setAlias( alias:String ):LinkProperties
		{
			_properties[ "alias" ] = alias;
			return this;
		}
		
		
		public function setDuration( duration:int ):LinkProperties
		{
			_properties[ "duration" ] = duration;
			return this;
		}
		
		
		public function setTags( tags:Array ):LinkProperties
		{
			if (tags == null) throw new Error( "tags cannot be null" );
			for each (var tag:* in tags)
			{
				if (!(tag is String))
				{
					throw new Error( "tags contain an invalid value" );
				}
			}
			_properties[ "tags" ] = tags;
			return this;
		}
		
		
		public function addControlParameter( key:String, value:String ):LinkProperties
		{
			if (!_properties.hasOwnProperty( "controlParameters" ))
			{
				_properties.controlParameters = {};
			}
			_properties.controlParameters[ key ] = value;
			return this;
		}
		
		
		public function setStage( stage:String ):LinkProperties
		{
			_properties[ "stage" ] = stage;
			return this;
		}
		
		
		public function toObject():Object
		{
			return _properties;
		}
		
	}
	
}
