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
 * @created 19/09/2020
 * @copyright https://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.events;

import org.json.JSONObject;

import io.branch.nativeExtensions.branch.utils.Errors;
import io.branch.referral.BranchError;

public class BranchUniversalObjectEvent
{
	public static final String GENERATE_SHORT_URL_SUCCESS = "generateShortUrl:success";
	public static final String GENERATE_SHORT_URL_FAILED  = "generateShortUrl:failed";


	public static String formatForEvent( String identifier, String requestId, String url, BranchError error )
	{
		try
		{
			JSONObject event = new JSONObject();

			event.put( "identifier", identifier );
			event.put( "requestId", requestId );

			if (url != null)
			{
				event.put( "url", url );
			}

			if (error != null)
			{
				JSONObject errorObject = new JSONObject();

				errorObject.put( "errorCode", error.getErrorCode() );
				errorObject.put( "message", error.getMessage() );

				event.put( "error", errorObject );
			}

			return event.toString();
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
		return "{}";
	}


}
