package io.branch.nativeExtensions.branch.functions.deprecated;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class CreateReferralCodeFunction extends BaseFunction implements FREFunction {
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);
		
		String prefix = getStringFromFREObject(args[0]);
		int amount = getIntFromFREObject(args[1]);
		int date = getIntFromFREObject(args[2]);
		String bucket = getStringFromFREObject(args[3]);
		int calculationType = getIntFromFREObject(args[4]);
		int location = getIntFromFREObject(args[5]);


		//BranchActivity.branch.getReferralCode(prefix, amount, new Date(date), bucket, calculationType, location, new BranchReferralInitListener() {
		//
		//	@Override
		//	public void onInitFinished(JSONObject referralCode, BranchError error) {
		//
		//		if (error == null) {
		//
		//			try {
		//
		//				String code = referralCode.getString("referral_code");
		//				BranchExtension.context.dispatchStatusEventAsync("CREATE_REFERRAL_CODE_SUCCESSED", code);
		//
		//			} catch (JSONException e) {
		//				BranchExtension.context.dispatchStatusEventAsync("CREATE_REFERRAL_CODE_FAILED", "");
		//				e.printStackTrace();
		//			}
		//
		//		} else
		//			BranchExtension.context.dispatchStatusEventAsync("CREATE_REFERRAL_CODE_FAILED", error.getMessage());
		//	}
		//});
		
		return null;
	}
}
