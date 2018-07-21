package io.branch.nativeExtensions.branch.functions;

import io.branch.nativeExtensions.branch.BranchActivity;
import io.branch.nativeExtensions.branch.BranchExtension;
import io.branch.referral.Branch.BranchReferralStateChangedListener;
import io.branch.referral.BranchError;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class RedeemRewardsFunction extends BaseFunction implements FREFunction {
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);
		
		int credits = getIntFromFREObject(args[0]);
		String bucket = getStringFromFREObject(args[1]);
		
		BranchActivity.branch.redeemRewards(bucket, credits, new BranchReferralStateChangedListener() {
			
			@Override
			public void onStateChanged(boolean changed, BranchError error) {
				
				if (error == null)
					BranchExtension.context.dispatchStatusEventAsync("REDEEM_REWARDS_SUCCESSED", "");
					
				else
					BranchExtension.context.dispatchStatusEventAsync("REDEEM_REWARDS_FAILED", error.getMessage());
			}
		});
		
		return null;
	}
}
