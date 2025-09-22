/**
 * @author Michael Archbold (https://github.com/marchbold)
 * @created 13/04/2017
 */
package io.branch.nativeExtensions.branch.utils;

import static com.distriqt.core.utils.FREUtils.DEBUG_ENABLED;

import com.distriqt.core.utils.IExtensionContext;

import io.branch.nativeExtensions.branch.Branch;

public class Errors
{


	public static void handleException( IExtensionContext context, Throwable e )
	{
		try
		{
			if (DEBUG_ENABLED)
			{
				e.printStackTrace();
			}

			if (context != null)
			{
				String message = "unknown";

				try
				{
					if (e != null)
					{
						message = e.getMessage();
					}
				}
				catch (Throwable var4)
				{
				}

				context.dispatchEvent( "extension:error", message );
			}
		}
		catch (Throwable var5)
		{
		}
	}


	public static void handleException( Throwable e )
	{
		handleException( Branch.context, e );
	}


}
