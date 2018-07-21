package io.branch.nativeExtensions.branch.functions;

import android.os.Build;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.distriqt.core.utils.FREUtils;

public class IsSupportedFunction implements FREFunction 
{

	@Override
	public FREObject call( FREContext context, FREObject[] args ) 
	{
		FREObject result = null;
		try
		{
			boolean isSupported = false;
			if (Build.VERSION.SDK_INT >= 15)
			{
				isSupported = true;
			}
			result = FREObject.newObject( isSupported );
		}
		catch (FREWrongThreadException e) 
		{
			FREUtils.handleException( context, e );
		}
		return result;
	}

}
