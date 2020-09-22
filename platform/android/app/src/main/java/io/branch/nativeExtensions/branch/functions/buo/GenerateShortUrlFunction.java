/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * @brief
 * @author marchbold
 * @created 19/09/2020
 * @copyright http://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.functions.buo;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import org.json.JSONObject;

import io.branch.nativeExtensions.branch.BranchContext;
import io.branch.nativeExtensions.branch.utils.Errors;

public class GenerateShortUrlFunction implements FREFunction
{

	@Override
	public FREObject call( FREContext freContext, FREObject[] args )
	{
		FREObject result = null;
		try
		{
			String requestId = args[0].getAsString();
			JSONObject buoProperties = new JSONObject( args[1].getAsString() );
			JSONObject linkProperties = new JSONObject( args[2].getAsString() );

			BranchContext context = (BranchContext)freContext;

			context.controller().generateShortUrl( requestId, buoProperties, linkProperties );

		}
		catch (Exception e)
		{
			Errors.handleException(e);
		}
		return result;
	}

}
