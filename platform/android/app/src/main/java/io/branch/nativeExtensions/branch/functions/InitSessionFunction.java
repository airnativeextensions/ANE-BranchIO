package io.branch.nativeExtensions.branch.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import io.branch.nativeExtensions.branch.BranchContext;
import io.branch.nativeExtensions.branch.controller.BranchOptions;
import io.branch.nativeExtensions.branch.utils.Errors;

public class InitSessionFunction implements FREFunction
{

	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		FREObject result = null;
		try
		{
			BranchContext ctx = (BranchContext)context;

			BranchOptions options = new BranchOptions();
			options.useTestKey = args[0].getProperty( "useTestKey" ).getAsBool();
			options.delayInitToCheckForSearchAds = args[0].getProperty( "delayInitToCheckForSearchAds" ).getAsBool();

			ctx.controller().initSession( options );
		}
		catch (Exception e)
		{
			Errors.handleException( context, e );
		}
		return result;
	}

}
