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

import com.distriqt.core.ActivityStateListener;
import com.distriqt.core.utils.IExtensionContext;

import org.json.JSONArray;
import org.json.JSONObject;

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

	private Branch _branch;


	////////////////////////////////////////////////////////////
	//	FUNCTIONALITY
	//

	public BranchController( IExtensionContext extensionContext )
	{
		_extContext = extensionContext;
	}


	public void dispose()
	{
		_branch = null;
		_extContext = null;
	}


	public void onNewIntent()
	{
		if (_branch != null)
		{
			// TODO
		}
	}


	public void init( boolean useTestKey )
	{
		Logger.d( TAG, "init( %b )", useTestKey );
		try
		{
			if (useTestKey)
			{
				_branch = Branch.getTestInstance( _extContext.getActivity().getApplicationContext() );
			}
			else
			{
				_branch = Branch.getInstance( _extContext.getActivity().getApplicationContext() );
			}

			_branch.initSession( new Branch.BranchReferralInitListener()
			{
				@Override
				public void onInitFinished( JSONObject referringParams, BranchError error )
				{
					if (error == null)
					{
						_extContext.dispatchEvent( "INIT_SUCCESSED", referringParams.toString().replace( "\\", "" ) );
					}
					else
					{
						_extContext.dispatchEvent( "INIT_FAILED", error.getMessage() );
					}
				}
			}, _extContext.getActivity().getIntent().getData(), _extContext.getActivity() );
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}
	}


	public void setIdentity( String userId )
	{
		Logger.d( TAG, "setIdentity( %s )", userId );
		if (_branch != null)
		{
			_branch.setIdentity( userId, new Branch.BranchReferralInitListener()
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
		if (_branch != null)
		{
			_branch.logout();
		}
	}


	public String getLatestReferringParams()
	{
		Logger.d( TAG, "getLatestReferringParams()" );
		if (_branch != null)
		{
			try
			{
				JSONObject sessionsParams = _branch.getLatestReferringParams();
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
		if (_branch != null)
		{
			try
			{
				JSONObject sessionsParams = _branch.getFirstReferringParams();
				return sessionsParams.toString().replace( "\\", "" );
			}
			catch (Exception e)
			{
				Errors.handleException( e );
			}
		}
		return "{}";
	}


	public void userCompletedAction( String action, String json )
	{
		Logger.d( TAG, "userCompletedAction( %s, %s )", action, json  );
		try
		{
			if (_branch != null)
			{
				JSONObject obj = new JSONObject( json );

				_branch.userCompletedAction( action, obj );
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
		if (_branch != null)
		{
			_branch.loadRewards( new Branch.BranchReferralStateChangedListener()
			{
				@Override
				public void onStateChanged( boolean changed, BranchError error )
				{
					if (error == null)
					{
						_extContext.dispatchEvent(
								"GET_CREDITS_SUCCESSED",
								String.valueOf( _branch.getCreditsForBucket( bucket ) )
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
			if (_branch != null)
			{
				_branch.redeemRewards( bucket, credits, new Branch.BranchReferralStateChangedListener()
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
			if (_branch != null)
			{
				_branch.getCreditHistory(bucket, new Branch.BranchListResponseListener() {

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
