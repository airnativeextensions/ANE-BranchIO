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
 * @created 16/11/2017
 * @copyright https://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.controller;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import com.distriqt.core.ActivityStateListener;
import com.distriqt.core.utils.DebugUtil;
import com.distriqt.core.utils.IExtensionContext;

import org.json.JSONArray;
import org.json.JSONObject;

import io.branch.indexing.BranchUniversalObject;
import io.branch.nativeExtensions.branch.events.BranchCreditsEvent;
import io.branch.nativeExtensions.branch.events.BranchEvent;
import io.branch.nativeExtensions.branch.events.BranchUniversalObjectEvent;
import io.branch.nativeExtensions.branch.utils.Errors;
import io.branch.nativeExtensions.branch.utils.Logger;
import io.branch.referral.Branch;
import io.branch.referral.BranchError;
import io.branch.referral.util.LinkProperties;
import io.branch.referral.validators.IntegrationValidator;

public class BranchController extends ActivityStateListener
{
	////////////////////////////////////////////////////////////
	//	CONSTANTS
	//

	private static final String TAG = BranchController.class.getSimpleName();


	////////////////////////////////////////////////////////////
	//	VARIABLES
	//


	private IExtensionContext _extContext;

	private Handler _handler;

	private boolean _initialised;


	////////////////////////////////////////////////////////////
	//	FUNCTIONALITY
	//

	public BranchController( IExtensionContext extensionContext )
	{
		_extContext = extensionContext;
		_handler = new Handler( Looper.getMainLooper() );
		_initialised = false;
	}


	public void dispose()
	{
		_extContext = null;
	}


	public void initSession( BranchOptions options )
	{
		Logger.d( TAG, "initSession( %b )", options.useTestKey );
		try
		{
			if (options.enableDebugging)
				Branch.enableLogging();

			Branch branch;
			if (options.useTestKey)
			{
				// Force test instance usage
				branch = Branch.getTestInstance( _extContext.getActivity().getApplication() );
			}
			else
			{
				// Auto method from manifest settings
				branch = Branch.getAutoInstance( _extContext.getActivity().getApplication() );
			}


			try
			{
				Uri dataUri = _extContext.getActivity().getIntent().getData();
				Bundle extras = _extContext.getActivity().getIntent().getExtras();

				Logger.d( TAG, "INTENT DATA: %s", dataUri == null ? "null" : dataUri.toString() );
				Logger.d( TAG, "INTENT EXTRAS: %s", DebugUtil.bundleToString( extras ) );

			}
			catch (Exception e)
			{
				e.printStackTrace();
			}


			//try
			//{
			//	// This triggers reinitialisation - without this Branch waits for activity lifecycle events
			//	// which may not occur until app minimised.
			//	Method method = branch.getClass().getDeclaredMethod( "registerAppReInit" );
			//	method.setAccessible( true );
			//	method.invoke( branch );
			//}
			//catch (Exception e)
			//{
			//	e.printStackTrace();
			//}


			_handler.postDelayed( new Runnable()
			{
				@Override
				public void run()
				{
					try
					{
						// Initialise Branch and session
						//Branch.getInstance().initSession(
						//		new Branch.BranchReferralInitListener()
						//		{
						//			@Override
						//			public void onInitFinished( JSONObject referringParams, BranchError error )
						//			{
						//				_initialised = true;
						//				BranchController.this.onInitFinished( referringParams, error );
						//			}
						//		},
						//		_extContext.getActivity().getIntent().getData(),
						//		_extContext.getActivity()
						//);

						Branch.sessionBuilder( _extContext.getActivity() )
							  .ignoreIntent( true )
							  .withCallback( new Branch.BranchReferralInitListener()
							  {
								  @Override
								  public void onInitFinished( JSONObject referringParams, BranchError error )
								  {
									  _initialised = true;
									  BranchController.this.onInitFinished( referringParams, error );
								  }
							  } )
							  .withData( _extContext.getActivity().getIntent().getData() )
							  .init();

					}
					catch (Exception e)
					{
						e.printStackTrace();
					}
				}
			}, 500 );

		}
		catch (Exception e)
		{
			Errors.handleException( e );
			_extContext.dispatchEvent( "INIT_FAILED", e.getMessage() );
		}
	}


	public void setIdentity( String userId )
	{
		Logger.d( TAG, "setIdentity( %s )", userId );
		if (Branch.getInstance() != null)
		{
			Branch.getInstance().setIdentity( userId, new Branch.BranchReferralInitListener()
			{
				@Override
				public void onInitFinished( JSONObject referringParams, BranchError error )
				{
					if (error == null)
					{
						_extContext.dispatchEvent( BranchEvent.SET_IDENTITY_SUCCESS, "" );
					}
					else
					{
						_extContext.dispatchEvent( BranchEvent.SET_IDENTITY_FAILED, error.getMessage() );
					}
				}
			} );
		}
	}


	public void logout()
	{
		Logger.d( TAG, "logout()" );
		if (Branch.getInstance() != null)
		{
			Branch.getInstance().logout();
		}
	}


	public String getLatestReferringParams()
	{
		Logger.d( TAG, "getLatestReferringParams()" );
		if (Branch.getInstance() != null)
		{
			try
			{
				JSONObject sessionsParams = Branch.getInstance().getLatestReferringParams();
				return sessionsParams.toString().replace( "\\", "" );
			}
			catch (Exception e)
			{
				Errors.handleException( e );
			}
		}
		return "{}";
	}


	public String getFirstReferringParams()
	{
		Logger.d( TAG, "getFirstReferringParams()" );
		if (Branch.getInstance() != null)
		{
			try
			{
				JSONObject sessionsParams = Branch.getInstance().getFirstReferringParams();
				return sessionsParams.toString().replace( "\\", "" );
			}
			catch (Exception e)
			{
				Errors.handleException( e );
			}
		}
		return "{}";
	}


	public void handleDeepLink( String link, boolean forceNewSession )
	{
		Logger.d( TAG, "handleDeepLink()" );
		try
		{
			Intent intent = new Intent( _extContext.getActivity(), _extContext.getActivity().getClass() );
			intent.putExtra( "branch", link );
			intent.putExtra( "branch_force_new_session", forceNewSession );
			_extContext.getActivity().startActivity( intent );
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
	}


	public boolean logEvent( String eventJSONString )
	{
		Logger.d( TAG, "logEvent( %s )", eventJSONString );
		try
		{
			JSONObject eventJSON = new JSONObject( eventJSONString );
			return BranchEventUtils.eventFromJSONObject( eventJSON )
								   .logEvent( _extContext.getActivity() );
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
		return false;
	}


	public void userCompletedAction( String action, String json )
	{
		Logger.d( TAG, "userCompletedAction( %s, %s )", action, json );
		try
		{
			if (Branch.getInstance() != null)
			{
				JSONObject obj = new JSONObject( json );

				Branch.getInstance().userCompletedAction( action, obj );
			}
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
	}


	public void getCredits( final String bucket )
	{
		Logger.d( TAG, "getCredits( %s )", bucket );
		if (Branch.getInstance() != null)
		{
			Branch.getInstance().loadRewards( new Branch.BranchReferralStateChangedListener()
			{
				@Override
				public void onStateChanged( boolean changed, BranchError error )
				{
					if (error == null)
					{
						_extContext.dispatchEvent(
								BranchCreditsEvent.GET_CREDITS_SUCCESS,
								String.valueOf( Branch.getInstance().getCreditsForBucket( bucket ) )
						);
					}
					else
					{
						_extContext.dispatchEvent(
								BranchCreditsEvent.GET_CREDITS_FAILED,
								error.getMessage()
						);
					}
				}
			} );
		}
	}


	public void redeemRewards( int credits, String bucket )
	{
		Logger.d( TAG, "redeemRewards( %d, %s )", credits, bucket );
		try
		{
			if (Branch.getInstance() != null)
			{
				Branch.getInstance().redeemRewards( bucket, credits, new Branch.BranchReferralStateChangedListener()
				{
					@Override
					public void onStateChanged( boolean changed, BranchError error )
					{
						if (error == null)
						{
							_extContext.dispatchEvent( BranchCreditsEvent.REDEEM_REWARDS_SUCCESS, "" );
						}
						else
						{
							_extContext.dispatchEvent( BranchCreditsEvent.REDEEM_REWARDS_FAILED, error.getMessage() );
						}
					}
				} );
			}
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
	}


	public void getCreditHistory( String bucket )
	{
		Logger.d( TAG, "getCreditHistory( %s )", bucket );
		try
		{
			if (Branch.getInstance() != null)
			{
				Branch.getInstance().getCreditHistory( bucket, new Branch.BranchListResponseListener()
				{

					@Override
					public void onReceivingResponse( JSONArray list, BranchError error )
					{
						if (error == null)
						{
							_extContext.dispatchEvent( BranchCreditsEvent.GET_CREDITS_HISTORY_SUCCESS, list.toString() );
						}
						else
						{
							_extContext.dispatchEvent( BranchCreditsEvent.GET_CREDITS_HISTORY_FAILED, error.getMessage() );
						}
					}
				} );
			}
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
	}


	//
	//	Branch.BranchReferralInitListener
	//

	public void onInitFinished( JSONObject referringParams, BranchError error )
	{
		try
		{
			Logger.d( TAG, "onInitFinished( %s, %s )",
					  referringParams == null ? "null" : referringParams.toString(),
					  error == null ? "null" : error.getMessage() );

			if (error == null)
			{
				if (referringParams != null)
				{
					_extContext.dispatchEvent( BranchEvent.INIT_SUCCESS, referringParams.toString().replace( "\\", "" ) );
				}
				else
				{
					_extContext.dispatchEvent( BranchEvent.INIT_SUCCESS, "{}" );
				}
			}
			else
			{
				_extContext.dispatchEvent( BranchEvent.INIT_FAILED, error.getMessage() );
			}
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
	}


	//
	//	Branch Universal Objects
	//

	public void generateShortUrl( final String requestId, JSONObject buoJSON, JSONObject linkJSON )
	{
		try
		{
			final String identifier = buoJSON.getString( "identifier" );

			LinkProperties lp = BranchUniversalObjectUtils.linkPropertiesFromJSONObject( linkJSON );

			BranchUniversalObject buo = BranchUniversalObjectUtils.buoFromJSONObject( buoJSON.getJSONObject( "properties" ) );

			buo.generateShortUrl( _extContext.getActivity(), lp, new Branch.BranchLinkCreateListener()
			{
				@Override
				public void onLinkCreate( String url, BranchError error )
				{
					Logger.d( TAG, "generateShortUrl:onLinkCreate:" );
					if (error == null)
					{
						_extContext.dispatchEvent(
								BranchUniversalObjectEvent.GENERATE_SHORT_URL_SUCCESS,
								BranchUniversalObjectEvent.formatForEvent( identifier, requestId, url, error )
						);
					}
					else
					{
						_extContext.dispatchEvent(
								BranchUniversalObjectEvent.GENERATE_SHORT_URL_FAILED,
								BranchUniversalObjectEvent.formatForEvent( identifier, requestId, url, error )
						);
					}
				}
			} );

		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
	}


	//
	//	ActivityStateListener
	//

	@Override
	public void onStart()
	{
		Logger.d( TAG, "onStart()" );
		try
		{
			// Start a new session with the new activity lifecycle start
			if (_initialised)
			{
				//Branch.getInstance( _extContext.getActivity() ).initSession(
				//		new Branch.BranchReferralInitListener()
				//		{
				//			@Override
				//			public void onInitFinished( JSONObject referringParams, BranchError error )
				//			{
				//				BranchController.this.onInitFinished( referringParams, error );
				//			}
				//		},
				//		_extContext.getActivity().getIntent().getData(),
				//		_extContext.getActivity()
				//);

				Branch.sessionBuilder( _extContext.getActivity() )
					  .ignoreIntent( false )
					  .withCallback( new Branch.BranchReferralInitListener()
					  {
						  @Override
						  public void onInitFinished( JSONObject referringParams, BranchError error )
						  {
							  _initialised = true;
							  BranchController.this.onInitFinished( referringParams, error );
						  }
					  } )
					  .withData( _extContext.getActivity().getIntent().getData() )
					  .init();
			}
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
	}


	@Override
	public void onResume()
	{
		Logger.d( TAG, "onResume()" );
	}


	@Override
	public void onRestart()
	{
		Logger.d( TAG, "onRestart()" );
	}


	public void onNewIntent()
	{
		Logger.d( TAG, "onNewIntent()" );
		onStart();
	}


	//
	//	DEBUG UTILS
	//


	public void validateIntegration()
	{
		Logger.d( TAG, "validateIntegration()" );
		try
		{
			IntegrationValidator.validate( _extContext.getActivity() );
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
	}


}
