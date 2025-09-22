/**
 * @author Michael Archbold (https://github.com/marchbold)
 * @created Jan 19, 2012
 */
package io.branch.nativeExtensions.branch;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import org.json.JSONObject;

import io.branch.nativeExtensions.branch.events.BranchEvent;
import io.branch.nativeExtensions.branch.utils.Errors;
import io.branch.nativeExtensions.branch.utils.Logger;
import io.branch.referral.Branch;
import io.branch.referral.BranchError;

public class BranchActivity extends Activity
{

	public static final String TAG = BranchActivity.class.getSimpleName();

	static public String extraPrefix = "io.branch.nativeExtensions.branch.BranchActivity";

	static public Branch branch;

	@Override
	protected void onStart()
	{
		super.onStart();

		try
		{
			Bundle extras = this.getIntent().getExtras();
			boolean useTestKey = extras.getBoolean( extraPrefix + ".useTestKey" );
			if (useTestKey)
				Branch.enableTestMode();
		}
		catch (Exception e)
		{
			Errors.handleException( e );
		}

		Branch branch = Branch.getAutoInstance( getApplicationContext() );


		//Branch.sessionBuilder(this)
		//		.withCallback( new Branch.BranchReferralInitListener()
		//		{
		//			@Override
		//			public void onInitFinished( @Nullable JSONObject referringParams, @Nullable BranchError error )
		//			{
		//				Logger.d( TAG, "onInitFinished( %s, %s )",
		//						referringParams == null ? "null" : referringParams.toString(),
		//						error == null ? "null" : error.getMessage() );
		//
		//				if (error == null)
		//				{
		//					String data = "";
		//					if (referringParams != null)
		//					{
		//						data = referringParams.toString().replace( "\\", "" );
		//					}
		//					BranchExtension.context.dispatchEvent( BranchEvent.INIT_SUCCESS, data );
		//				}
		//				else
		//				{
		//					BranchExtension.context.dispatchEvent( BranchEvent.INIT_FAILED, error.getMessage() );
		//				}
		//				finish();
		//			}
		//		} )
		//		.withData(getIntent().getData())
		//		.init();

//		Branch.getInstance().initSession(
//				new Branch.BranchReferralInitListener()
//				{
//					@Override
//					public void onInitFinished( JSONObject referringParams, BranchError error )
//					{
//						Logger.d( TAG, "onInitFinished( %s, %s )",
//								  referringParams == null ? "null" : referringParams.toString(),
//								  error == null ? "null" : error.getMessage() );
//
//						if (error == null)
//						{
//							BranchExtension.context.dispatchEvent( BranchEvent.INIT_SUCCESS, referringParams.toString().replace( "\\", "" ) );
//						}
//						else
//						{
//							BranchExtension.context.dispatchEvent( BranchEvent.INIT_FAILED, error.getMessage() );
//						}
//						finish();
//					}
//				},
//				getIntent().getData(),
//				this
//		);


		Branch.sessionBuilder( this )
			  .ignoreIntent( true )
			  .withCallback( new Branch.BranchReferralInitListener()
			  {
				  @Override
				  public void onInitFinished( JSONObject referringParams, BranchError error )
				  {
					  Logger.d( TAG, "onInitFinished( %s, %s )",
								referringParams == null ? "null" : referringParams.toString(),
								error == null ? "null" : error.getMessage() );

					  if (error == null)
					  {
						  io.branch.nativeExtensions.branch.Branch.context.dispatchEvent(
								  BranchEvent.INIT_SUCCESS,
								  referringParams == null ? "" : referringParams.toString().replace( "\\", "" )
						  );
					  }
					  else
					  {
						  io.branch.nativeExtensions.branch.Branch.context.dispatchEvent(
								  BranchEvent.INIT_FAILED,
								  error.getMessage()
						  );
					  }
					  finish();
				  }
			  } )
			  .withData( getIntent().getData() )
			  .init();
	}


	@Override
	protected void onCreate( Bundle savedInstanceState )
	{
		super.onCreate( savedInstanceState );
		Logger.d( TAG, "onCreate()" );
	}


	@Override
	public void onNewIntent( Intent intent )
	{
		Logger.d( TAG, "onNewIntent()" );
		//this.setIntent( intent );
	}


}
