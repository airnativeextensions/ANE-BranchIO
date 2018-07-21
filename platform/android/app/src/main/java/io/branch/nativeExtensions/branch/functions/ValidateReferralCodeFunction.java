package io.branch.nativeExtensions.branch.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class ValidateReferralCodeFunction extends BaseFunction implements FREFunction {
	
	String _code;
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);
		
		_code = getStringFromFREObject(args[0]);
		
		//BranchActivity.branch.validateReferralCode(_code, new BranchReferralInitListener() {
		//
		//	@Override
		//	public void onInitFinished(JSONObject referralCode, BranchError error) {
		//
		//		if (error == null) {
		//
		//			try {
		//
		//				if (!referralCode.has("error_message")) {
		//
		//					String referral_code = referralCode.getString("referral_code");
		//
		//					if (referral_code.equals(_code))
		//						BranchExtension.context.dispatchStatusEventAsync("VALIDATE_REFERRAL_CODE_SUCCESSED", "");
		//
		//					else
		//						BranchExtension.context.dispatchStatusEventAsync("VALIDATE_REFERRAL_CODE_FAILED", "invalid (should never happen)");
		//
		//				} else
		//					BranchExtension.context.dispatchStatusEventAsync("VALIDATE_REFERRAL_CODE_FAILED", "invalid");
		//
		//			} catch (JSONException e) {
		//
		//				BranchExtension.context.dispatchStatusEventAsync("VALIDATE_REFERRAL_CODE_FAILED", "invalid exception");
		//
		//				 e.printStackTrace();
		//			}
		//
		//		} else
		//			BranchExtension.context.dispatchStatusEventAsync("VALIDATE_REFERRAL_CODE_FAILED", error.getMessage());
		//	}
		//});
		
		return null;
	}
}
