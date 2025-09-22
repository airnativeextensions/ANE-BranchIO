/**
 * @author 		Michael Archbold (https://github.com/marchbold)
 * @created		19/9/20
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
