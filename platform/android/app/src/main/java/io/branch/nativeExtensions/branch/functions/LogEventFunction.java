/**
 * @author Michael Archbold (https://github.com/marchbold)
 * @created 28/07/2018
 */
package io.branch.nativeExtensions.branch.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import io.branch.nativeExtensions.branch.BranchContext;
import io.branch.nativeExtensions.branch.utils.Errors;

public class LogEventFunction implements FREFunction
{

	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		FREObject result = null;
		try
		{
			BranchContext ctx = (BranchContext) context;

			String eventJSONString = args[0].getAsString();

			boolean success = ctx.controller().logEvent( eventJSONString );

			result = FREObject.newObject( success );
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
		return result;
	}
}
