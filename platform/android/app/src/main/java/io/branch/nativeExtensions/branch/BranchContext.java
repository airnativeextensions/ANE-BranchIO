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
 * @brief  		Main Context for an ActionScript Native Extension
 * @author 		Michael Archbold
 * @created		Jan 19, 2012
 * @copyright	http://distriqt.com/copyright/license.txt
 *
 */
package io.branch.nativeExtensions.branch;

import android.content.Intent;
import android.content.res.Configuration;

import com.adobe.air.ActivityResultCallback;
import com.adobe.air.AndroidActivityWrapper;
import com.adobe.air.StateChangeCallback;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.distriqt.core.utils.IExtensionContext;

import java.util.HashMap;
import java.util.Map;

import io.branch.nativeExtensions.branch.controller.BranchController;
import io.branch.nativeExtensions.branch.functions.GetCreditsFunction;
import io.branch.nativeExtensions.branch.functions.GetCreditsHistoryFunction;
import io.branch.nativeExtensions.branch.functions.GetFirstReferringParamsFunction;
import io.branch.nativeExtensions.branch.functions.GetLatestReferringParamsFunction;
import io.branch.nativeExtensions.branch.functions.GetShortUrlFunction;
import io.branch.nativeExtensions.branch.functions.HandleDeepLinkFunction;
import io.branch.nativeExtensions.branch.functions.ImplementationFunction;
import io.branch.nativeExtensions.branch.functions.InitSessionFunction;
import io.branch.nativeExtensions.branch.functions.InvokeFunction;
import io.branch.nativeExtensions.branch.functions.IsSupportedFunction;
import io.branch.nativeExtensions.branch.functions.LogEventFunction;
import io.branch.nativeExtensions.branch.functions.LogoutFunction;
import io.branch.nativeExtensions.branch.functions.RedeemRewardsFunction;
import io.branch.nativeExtensions.branch.functions.SetIdentityFunction;
import io.branch.nativeExtensions.branch.functions.UserCompletedActionFunction;
import io.branch.nativeExtensions.branch.functions.ValidateIntegrationFunction;
import io.branch.nativeExtensions.branch.functions.VersionFunction;
import io.branch.nativeExtensions.branch.functions.buo.GenerateShortUrlFunction;
import io.branch.nativeExtensions.branch.utils.Logger;
import io.branch.referral.BuildConfig;

public class BranchContext extends FREContext implements IExtensionContext, ActivityResultCallback, StateChangeCallback
{
	public static final String TAG = BranchContext.class.getSimpleName();
	public static final String VERSION = BuildConfig.VERSION_NAME;
	public static final String IMPLEMENTATION = "Android";


	////////////////////////////////////////////////////////////
	//	VARIABLES
	//

	public boolean v = false;

	private AndroidActivityWrapper _aaw;

	private BranchController _controller = null;



	////////////////////////////////////////////////////////////
	//	FUNCTIONALITY
	//

	public BranchContext()
	{
		_aaw = AndroidActivityWrapper.GetAndroidActivityWrapper();
		_aaw.addActivityResultListener( this );
		_aaw.addActivityStateChangeListner( this );
	}


	@Override
	public void dispose() 
	{
		if (_controller != null)
		{
			_controller.dispose();
			_controller = null;
		}
		if (_aaw != null)
		{
			_aaw.removeActivityResultListener( this );
			_aaw.removeActivityStateChangeListner( this );
			_aaw = null;
		}
	}

	
	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Map<String, FREFunction> functionMap = new HashMap<>();

		functionMap.put( "isSupported", new IsSupportedFunction() );
		functionMap.put( "version", new VersionFunction() );
		functionMap.put( "implementation", new ImplementationFunction() );

		functionMap.put( "invoke", new InvokeFunction() );

		functionMap.put( "initSession", new InitSessionFunction() );
		functionMap.put( "setIdentity", new SetIdentityFunction() );
		functionMap.put( "logout", new LogoutFunction() );
		functionMap.put( "getLatestReferringParams", new GetLatestReferringParamsFunction() );
		functionMap.put( "getFirstReferringParams", new GetFirstReferringParamsFunction() );
		functionMap.put( "userCompletedAction", new UserCompletedActionFunction() );
		functionMap.put( "getCredits", new GetCreditsFunction() );
		functionMap.put( "redeemRewards", new RedeemRewardsFunction() );
		functionMap.put( "getCreditsHistory", new GetCreditsHistoryFunction() );

		functionMap.put( "handleDeepLink", new HandleDeepLinkFunction() );


		//
		//	TRACKING
		//

		functionMap.put( "logEvent", new LogEventFunction() );


		//
		// BRANCH UNIVERSAL OBJECTS
		//


		functionMap.put( "buo_generateShortUrl", new GenerateShortUrlFunction() );



		//
		// LEGACY
		//

		functionMap.put( "getShortUrl", new GetShortUrlFunction() );


		//
		//	DEBUG
		//

		functionMap.put( "validateIntegration", new ValidateIntegrationFunction() );


		return functionMap;
	}


	//
	//	CONTROLLER
	//

	public BranchController controller()
	{
		if (_controller == null)
		{
			_controller = new BranchController( this );
		}
		return _controller;
	}



	//
	//	ActivityResultCallback
	//

	@Override
	public void onActivityResult( int requestCode, int resultCode, Intent intent )
	{
		if (_controller != null)
		{
			_controller.onActivityResult( requestCode, resultCode, intent );
		}
	}


	//
	//	StateChangeCallback
	//

	@Override
	public void onActivityStateChanged( AndroidActivityWrapper.ActivityState state )
	{
		Logger.d( TAG, "onActivityStateChanged()" );
		if (_controller != null)
		{
			switch (state)
			{
				case STARTED:
					_controller.onStart();
					break;

				case STOPPED:
					_controller.onStop();
					break;

				case PAUSED:
					_controller.onPause();
					break;

				case RESTARTED:
					_controller.onRestart();
					break;

				case DESTROYED:
					_controller.onDestroy();
					break;

				case RESUMED:
					_controller.onResume();
					break;
			}
		}
	}


	@Override
	public void onConfigurationChanged( Configuration paramConfiguration )
	{
		if (_controller != null)
		{
			_controller.onConfigurationChanged( paramConfiguration );
		}
	}


	//
	//	IExtensionContext
	//

	@Override
	public void dispatchEvent( final String code, final String data )
	{
		try
		{
			dispatchStatusEventAsync( code, data );
		}
		catch (Exception e)
		{
		}
	}
	
}
