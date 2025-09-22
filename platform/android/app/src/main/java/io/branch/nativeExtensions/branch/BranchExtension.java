/**
 * @author Michael Archbold (https://github.com/marchbold)
 * @created Jan 19, 2012
 */
package io.branch.nativeExtensions.branch;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class BranchExtension implements FREExtension
{

	@Override
	public FREContext createContext( String arg0 )
	{
		Branch.context = new BranchContext();
		return (FREContext) Branch.context;
	}


	@Override
	public void dispose()
	{
		if (Branch.context != null)
		{
			((FREContext) Branch.context).dispose();
			Branch.context = null;
		}
	}


	@Override
	public void initialize()
	{
	}

}
