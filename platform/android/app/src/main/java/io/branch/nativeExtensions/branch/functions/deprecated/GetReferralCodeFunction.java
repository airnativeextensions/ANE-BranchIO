package io.branch.nativeExtensions.branch.functions.deprecated;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class GetReferralCodeFunction extends BaseFunction implements FREFunction {
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);
		
		//BranchActivity.branch.getReferralCode(new BranchReferralInitListener() {
		//
		//	@Override
		//	public void onInitFinished(JSONObject referralCode, BranchError error) {
		//
		//		if (error == null) {
		//
		//			try {
		//
		//				String code = referralCode.getString("referral_code");
		//				BranchExtension.context.dispatchStatusEventAsync("GET_REFERRAL_CODE_SUCCESSED", code);
		//
		//			} catch (JSONException e) {
		//				BranchExtension.context.dispatchStatusEventAsync("GET_REFERRAL_CODE_FAILED", "");
		//				e.printStackTrace();
		//			}
		//
		//		} else
		//			BranchExtension.context.dispatchStatusEventAsync("GET_REFERRAL_CODE_FAILED", error.getMessage());
		//	}
		//});
		
		return null;
	}
}
