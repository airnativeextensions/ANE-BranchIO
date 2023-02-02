package io.branch.nativeExtensions.branch.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import io.branch.nativeExtensions.branch.BranchContext;
import io.branch.nativeExtensions.branch.utils.Errors;

public class UserCompletedActionFunction implements FREFunction
{

	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		FREObject result = null;
		try
		{
			BranchContext ctx = (BranchContext) context;

			String action = args[0].getAsString();
			String json   = args[1].getAsString();

			ctx.controller().userCompletedAction( action, json );
		}
		catch (Exception e)
		{
			Errors.handleException( context, e );
		}
		return result;
	}

}
