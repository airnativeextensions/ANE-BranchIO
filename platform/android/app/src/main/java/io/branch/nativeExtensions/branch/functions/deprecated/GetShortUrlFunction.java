package io.branch.nativeExtensions.branch.functions.deprecated;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

import io.branch.nativeExtensions.branch.BranchExtension;
import io.branch.nativeExtensions.branch.utils.Errors;
import io.branch.referral.Branch.BranchLinkCreateListener;
import io.branch.referral.BranchError;

public class GetShortUrlFunction extends BaseFunction implements FREFunction
{
	
	@Override
	public FREObject call(FREContext context, FREObject[] args)
	{
		FREObject result = null;
		try
		{


		}
		catch (Exception e)
		{
			Errors.handleException( context, e );
		}

		List<String> tags = getListOfStringFromFREArray((FREArray)args[0]);
		String channel = getStringFromFREObject(args[1]);
		String feature = getStringFromFREObject(args[2]);
		String stage = getStringFromFREObject(args[3]);
		String json = getStringFromFREObject(args[4]);
		String alias = getStringFromFREObject(args[5]);
		int type = getIntFromFREObject(args[6]);
		
		try {
			
			JSONObject obj = new JSONObject(json);
			
			BranchLinkCreateListener callback = new BranchLinkCreateListener() {
				
				@Override
				public void onLinkCreate(String url, BranchError error) {
					
					if (error == null)
						BranchExtension.context.dispatchStatusEventAsync("GET_SHORT_URL_SUCCESSED", url);
						
					else
						BranchExtension.context.dispatchStatusEventAsync("GET_SHORT_URL_FAILED", error.getMessage());
					
				}
			};
			
			//if (alias.length() != 0)
			//	BranchActivity.branch.getShortUrl(alias, tags, channel, feature, stage, obj, callback);
			//
			//else if (type != -1)
			//	BranchActivity.branch.getShortUrl(type, tags, channel, feature, stage, obj, callback);
			//
			//else
			//	BranchActivity.branch.getShortUrl(tags, channel, feature, stage, obj, callback);
			
		} catch (JSONException t) {
			
			BranchExtension.context.dispatchStatusEventAsync("GET_SHORT_URL_FAILED", "Could not parse malformed JSON");
			t.printStackTrace();
		}
		
		return null;
	}
}
