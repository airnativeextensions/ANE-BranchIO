/**
 * @author Michael Archbold (https://github.com/marchbold)
 * @created 19/09/2020
 */
package io.branch.nativeExtensions.branch.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.distriqt.core.utils.FREUtils;

import io.branch.nativeExtensions.branch.BranchContext;

public class IsSupportedFunction implements FREFunction
{

	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		FREObject result = null;
		try
		{
			BranchContext ctx = (BranchContext) context;
			boolean isSupported = ctx.controller().isSupported();
			result = FREObject.newObject( isSupported );
		}
		catch (FREWrongThreadException e)
		{
			FREUtils.handleException( context, e );
		}
		return result;
	}

}
