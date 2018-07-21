package io.branch.nativeExtensions.branch;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class BranchExtension implements FREExtension
{
	public static BranchContext context;

	public static String ID = "io.branch.nativeExtensions.Branch";


	@Override
	public FREContext createContext( String arg0 )
	{
		context = new BranchContext();
		return context;
	}


	@Override
	public void dispose()
	{
		if (context != null)
		{
			context.dispose();
			context = null;
		}
	}


	@Override
	public void initialize()
	{
	}

}
