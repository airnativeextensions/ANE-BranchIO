/**
 * @author Michael Archbold (https://github.com/marchbold)
 * @created 13/04/2017
 */
package io.branch.nativeExtensions.branch.utils;

import com.distriqt.core.utils.LogUtil;

import io.branch.nativeExtensions.branch.Branch;

public class Logger
{

	public static void d( String TAG, String message, Object... args )
	{
		LogUtil.d(
				Branch.ID,
				TAG,
				message,
				args );
	}


	public static void i( String TAG, String message, Object... args )
	{
		LogUtil.i(
				Branch.ID,
				TAG,
				message,
				args );
	}


}
