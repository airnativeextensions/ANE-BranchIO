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
 * @created		22/9/20
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.buo
{
	
	public class ContentMetadata
	{
		////////////////////////////////////////////////////////
		//  CONSTANTS
		//
		
		private static const TAG:String = "ContentMetadata";
		
		
		////////////////////////////////////////////////////////
		//  VARIABLES
		//
		
		private var _properties:Object;
		
		
		////////////////////////////////////////////////////////
		//  FUNCTIONALITY
		//
		
		public function ContentMetadata()
		{
			_properties = {};
		}
		
		
		public function addCustomMetadata( key:String, value:String ):ContentMetadata
		{
			_properties[ key ] = value;
			return this;
		}
		
		
		public function toObject():Object
		{
			return _properties;
		}
		
	}
}
