package io.branch.nativeExtensions.branch;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;

import org.json.JSONObject;

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

		Bundle extras = this.getIntent().getExtras();
		Boolean useTestKey = extras.getBoolean( extraPrefix + ".useTestKey" );

		if (useTestKey)
		{
			Branch.getTestInstance( this.getApplication() );
		}
		else
		{
			Branch.getAutoInstance( this.getApplication() );
		}

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
							BranchExtension.context.dispatchEvent( "INIT_SUCCESSED", referringParams.toString().replace( "\\", "" ) );
						}
						else
						{
							BranchExtension.context.dispatchEvent( "INIT_FAILED", error.getMessage() );
						}
						finish();
					}
				},
				getIntent().getData(),
				this
		);
	}


	@Override
	protected void onCreate( @Nullable Bundle savedInstanceState )
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
