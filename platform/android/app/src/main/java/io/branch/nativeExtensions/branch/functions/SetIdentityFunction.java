package io.branch.nativeExtensions.branch.functions;

import io.branch.nativeExtensions.branch.BranchActivity;
import io.branch.nativeExtensions.branch.BranchExtension;
import io.branch.referral.Branch.BranchReferralInitListener;
import io.branch.referral.BranchError;

import org.json.JSONObject;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

public class SetIdentityFunction extends BaseFunction {
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);
		
		String userId = getStringFromFREObject(args[0]);
		
		BranchActivity.branch.setIdentity(userId, new BranchReferralInitListener() {
			
			@Override
			public void onInitFinished(JSONObject referringParams, BranchError error) {
				
				if (error == null) {
					
					BranchExtension.context.dispatchStatusEventAsync("SET_IDENTITY_SUCCESSED", "");
					
				} else {
					
					BranchExtension.context.dispatchStatusEventAsync("SET_IDENTITY_FAILED", error.getMessage());
				}

			}
		});
	
		return null;
	}

}
