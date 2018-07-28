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
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @created 16/11/2017
 * @copyright http://distriqt.com/copyright/license.txt
 */
package io.branch.nativeExtensions.branch.controller;

import android.content.Intent;

import com.distriqt.core.ActivityStateListener;
import com.distriqt.core.utils.IExtensionContext;

import org.json.JSONArray;
import org.json.JSONObject;

import io.branch.nativeExtensions.branch.BranchActivity;
import io.branch.nativeExtensions.branch.utils.Errors;
import io.branch.nativeExtensions.branch.utils.Logger;
import io.branch.referral.Branch;
import io.branch.referral.BranchError;

public class BranchController extends ActivityStateListener
{
	////////////////////////////////////////////////////////////
	//	CONSTANTS
	//

	public static final String TAG = BranchController.class.getSimpleName();


	////////////////////////////////////////////////////////////
	//	VARIABLES
	//


	private IExtensionContext _extContext;



	////////////////////////////////////////////////////////////
	//	FUNCTIONALITY
	//

	public BranchController( IExtensionContext extensionContext )
	{
		_extContext = extensionContext;
	}


	public void dispose()
	{
		_extContext = null;
	}


	public void onNewIntent()
	{
		Logger.d( TAG, "onNewIntent()" );
		// TODO
		if (Branch.getInstance() != null)
		{
			//_extContext.getActivity().setIntent(  );
		}
	}


	public void initSession( BranchOptions options )
	{
		Logger.d( TAG, "initSession( %b )", options.useTestKey );
		try
		{
			Intent i = new Intent( _extContext.getActivity().getApplicationContext(), BranchActivity.class );
			i.putExtra( BranchActivity.extraPrefix + ".useTestKey", options.useTestKey );
			_extContext.getActivity().startActivity(i);

			//
			//	THIS DOESN'T WORK HERE
			// Branch must need some activity callback that we can't manually trigger

			//if (options.useTestKey)
			//{
			//	Branch.getTestInstance( _extContext.getActivity().getApplication() );
			//}
			//else
			//{
			//	Branch.getAutoInstance( _extContext.getActivity().getApplication() );
			//}
			//

			Branch.getInstance().initSession(
					new Branch.BranchReferralInitListener()
					{
						@Override
						public void onInitFinished( JSONObject referringParams, BranchError error )
						{
							Logger.d( TAG, "onInitFinished( %s, %s )",
									referringParams == null ? "null" : referringParams.toString(),
									error == null ? "null" : error.getMessage() );

							if (error == null)
							{
								_extContext.dispatchEvent( "INIT_SUCCESSED", referringParams.toString().replace( "\\", "" ) );
							}
							else
							{
								_extContext.dispatchEvent( "INIT_FAILED", error.getMessage() );
							}
						}
					},
					_extContext.getActivity().getIntent().getData(),
					_extContext.getActivity()
			);


			//IntegrationValidator.validate( _extContext.getActivity() );

		}
		catch (Exception e)
		{
			Errors.handleException( e );
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
						_extContext.dispatchEvent( "SET_IDENTITY_SUCCESSED", "" );
					}
					else
					{
						_extContext.dispatchEvent( "SET_IDENTITY_FAILED", error.getMessage() );
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
		Logger.d( TAG, "userCompletedAction( %s, %s )", action, json  );
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
		Logger.d( TAG, "getCredits( %s )", bucket  );
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
								"GET_CREDITS_SUCCESSED",
								String.valueOf( Branch.getInstance().getCreditsForBucket( bucket ) )
						);
					}
					else
					{
						_extContext.dispatchEvent(
								"GET_CREDITS_FAILED",
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
							_extContext.dispatchEvent( "REDEEM_REWARDS_SUCCESSED", "" );
						}
						else
						{
							_extContext.dispatchEvent( "REDEEM_REWARDS_FAILED", error.getMessage() );
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
				Branch.getInstance().getCreditHistory(bucket, new Branch.BranchListResponseListener() {

					@Override
					public void onReceivingResponse( JSONArray list, BranchError error)
					{
						if (error == null)
						{
							_extContext.dispatchEvent( "GET_CREDITS_HISTORY_SUCCESSED", list.toString() );
						}
						else
						{
							_extContext.dispatchEvent( "GET_CREDITS_HISTORY_FAILED", error.getMessage() );
						}
					}
				});
			}
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
	}

















}
