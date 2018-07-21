package io.branch.nativeExtensions.branch;

import io.branch.referral.Branch;
import io.branch.referral.Branch.BranchReferralInitListener;
import io.branch.referral.BranchError;

import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class BranchActivity extends Activity {
	
	static public String extraPrefix = "io.branch.nativeExtensions.branch.BranchActivity";
	
	static public Branch branch;
	
	@Override
	protected void onStart() {
		super.onStart();
		
		Bundle extras = this.getIntent().getExtras();
		Boolean useTestKey = extras.getBoolean(extraPrefix + ".useTestKey");
		
		branch = useTestKey ? Branch.getTestInstance(getApplicationContext()) : Branch.getInstance(getApplicationContext());
		
		branch.initSession(new BranchReferralInitListener() {
			
			@Override
			public void onInitFinished(JSONObject referringParams, BranchError error) {
				
				if (error == null) {
					
					BranchExtension.context.dispatchStatusEventAsync("INIT_SUCCESSED", referringParams.toString().replace("\\", ""));
					
				} else {
					
					BranchExtension.context.dispatchStatusEventAsync("INIT_FAILED", error.getMessage());
				}
				
				finish();
				
			}
		}, getIntent().getData(), this);
	}
	
	@Override
	public void onNewIntent(Intent intent) {
		this.setIntent(intent);
	}

}
