package io.branch.nativeExtensions.branch.functions;

import io.branch.nativeExtensions.branch.BranchActivity;
import io.branch.nativeExtensions.branch.BranchExtension;
import io.branch.referral.Branch.BranchReferralInitListener;
import io.branch.referral.BranchError;

import org.json.JSONObject;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class ApplyReferralCodeFunction extends BaseFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);
		
		String code = getStringFromFREObject(args[0]);
		
		BranchActivity.branch.applyReferralCode(code, new BranchReferralInitListener() {
			
			@Override
			public void onInitFinished(JSONObject referralCode, BranchError error) {
				
				if (error == null) {
					
					if (!referralCode.has("error_message"))
						BranchExtension.context.dispatchStatusEventAsync("APPLY_REFERRAL_CODE_SUCCESSED", referralCode.toString().replace("\\", ""));
					
					else
						BranchExtension.context.dispatchStatusEventAsync("APPLY_REFERRAL_CODE_FAILED", "invalid code");
					
				} else
					BranchExtension.context.dispatchStatusEventAsync("APPLY_REFERRAL_CODE_FAILED", error.getMessage());
			}
		});
		
		return null;
	}
}
