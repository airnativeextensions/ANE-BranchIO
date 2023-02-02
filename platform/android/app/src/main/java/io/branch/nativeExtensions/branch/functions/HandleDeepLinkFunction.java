/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * https://distriqt.com
 *
 * @brief
 * @author Michael Archbold (https://github.com/marchbold)
 * @created 28/07/2018
 * @copyright https://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import io.branch.nativeExtensions.branch.BranchContext;
import io.branch.nativeExtensions.branch.utils.Errors;

public class HandleDeepLinkFunction implements FREFunction
{

	@Override
	public FREObject call( FREContext context, FREObject[] args )
	{
		FREObject result = null;
		try
		{
			String  link            = args[0].getAsString();
			boolean forceNewSession = args[1].getAsBool();

			BranchContext ctx = (BranchContext) context;
			ctx.controller().handleDeepLink( link, forceNewSession );

		}
		catch (Exception e)
		{
			Errors.handleException( context, e );
		}
		return result;
	}

}
