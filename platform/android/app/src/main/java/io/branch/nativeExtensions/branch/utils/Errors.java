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
 * @created 13/04/2017
 * @copyright http://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.utils;

import com.adobe.fre.FREContext;
import com.distriqt.core.utils.FREUtils;
import io.branch.nativeExtensions.branch.BranchExtension;

public class Errors
{


	public static void handleException( FREContext context, Throwable e )
	{
		FREUtils.handleException( context, e );
	}


	public static void handleException( Throwable e )
	{
		handleException( BranchExtension.context, e );
	}


}
