package io.branch.nativeExtensions.branch.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import io.branch.nativeExtensions.branch.BranchContext;
import io.branch.nativeExtensions.branch.utils.Errors;

public class InitSessionFunction implements FREFunction
{

	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		FREObject result = null;
		try
		{
			boolean useTestKey = args[0].getAsBool();

			BranchContext ctx = (BranchContext)context;

			ctx.controller().initSession( useTestKey );
		}
		catch (Exception e)
		{
			Errors.handleException( context, e );
		}
		return result;
	}

}
