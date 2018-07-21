package io.branch.nativeExtensions.branch.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import io.branch.nativeExtensions.branch.BranchContext;
import io.branch.nativeExtensions.branch.utils.Errors;

public class InvokeFunction implements FREFunction
{

	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		try
		{
			BranchContext ctx = (BranchContext)context;

			ctx.controller().onNewIntent();
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
		return null;
	}

}
