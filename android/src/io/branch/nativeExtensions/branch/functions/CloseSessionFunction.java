package io.branch.nativeExtensions.branch.functions;

import io.branch.nativeExtensions.branch.BranchActivity;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

public class CloseSessionFunction extends BaseFunction {
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);
		
		BranchActivity.branch.closeSession();
		
		return null;
	}
}
