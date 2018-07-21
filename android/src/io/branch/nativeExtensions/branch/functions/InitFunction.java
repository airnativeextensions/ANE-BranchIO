package io.branch.nativeExtensions.branch.functions;

import io.branch.nativeExtensions.branch.BranchExtension;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;

public class InitFunction extends BaseFunction {
	
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		super.call(context, args);
		
		Boolean useTestKey = getBooleanFromFREObject(args[0]);
		
		BranchExtension.context.initActivity(useTestKey);
		
		return null;
	}

}
