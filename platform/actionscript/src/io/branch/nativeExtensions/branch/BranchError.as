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
	
	public class BranchError
	{
		////////////////////////////////////////////////////////
		//  CONSTANTS
		//
		
		private static const TAG:String = "BranchError";
		
		
		////////////////////////////////////////////////////////
		//  VARIABLES
		//
		
		public var errorCode:int = -1;
		
		public var message:String = "";
		
		
		////////////////////////////////////////////////////////
		//  FUNCTIONALITY
		//
		
		public function BranchError()
		{
		}
		
		
		public static function fromObject( data:Object ):BranchError
		{
			if (data == null) return null;
			
			var error:BranchError = new BranchError();
			if (data.hasOwnProperty( "errorCode" )) error.errorCode = data.errorCode;
			if (data.hasOwnProperty( "message" )) error.message = data.message;
			return error;
		}
		
	}
	
}
