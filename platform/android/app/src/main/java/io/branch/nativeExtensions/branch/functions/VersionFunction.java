package io.branch.nativeExtensions.branch.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.distriqt.core.utils.FREUtils;

import io.branch.nativeExtensions.branch.BranchContext;

public class VersionFunction implements FREFunction
{

	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		FREObject result = null;
		try
		{
			result = FREObject.newObject( BranchContext.VERSION );
		}
		catch (FREWrongThreadException e)
		{
			FREUtils.handleException( context, e );
		}
		return result;
	}

}
