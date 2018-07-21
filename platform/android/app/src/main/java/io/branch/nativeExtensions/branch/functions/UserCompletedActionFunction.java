package io.branch.nativeExtensions.branch.functions;

import org.json.JSONException;
import org.json.JSONObject;

import io.branch.nativeExtensions.branch.BranchActivity;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class UserCompletedActionFunction extends BaseFunction implements FREFunction {
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);
		
		String action = getStringFromFREObject(args[0]);
		String json = getStringFromFREObject(args[1]);
		
		try {
			
			JSONObject obj = new JSONObject(json);
			
			BranchActivity.branch.userCompletedAction(action, obj);
			
		} catch (JSONException t) {
			
			t.printStackTrace();
		}
		
		return null;
	}
}
