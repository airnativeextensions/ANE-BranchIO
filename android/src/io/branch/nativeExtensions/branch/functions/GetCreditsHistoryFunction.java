package io.branch.nativeExtensions.branch.functions;

import io.branch.nativeExtensions.branch.BranchActivity;
import io.branch.nativeExtensions.branch.BranchExtension;
import io.branch.referral.Branch.BranchListResponseListener;
import io.branch.referral.BranchError;

import org.json.JSONArray;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class GetCreditsHistoryFunction extends BaseFunction implements FREFunction {
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);
		
		String bucket = getStringFromFREObject(args[0]);
		
		BranchActivity.branch.getCreditHistory(bucket, new BranchListResponseListener() {
			
			@Override
			public void onReceivingResponse(JSONArray list, BranchError error) {
				
				if (error == null)
					BranchExtension.context.dispatchStatusEventAsync("GET_CREDITS_HISTORY_SUCCESSED", list.toString());
					
				else
					BranchExtension.context.dispatchStatusEventAsync("GET_CREDITS_HISTORY_FAILED", error.getMessage());
			}
		});
		
		return null;
	}
}
