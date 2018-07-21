package io.branch.nativeExtensions.branch;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class BranchExtension implements FREExtension {
	
	static public BranchExtensionContext context;
	
	@Override
	public FREContext createContext(String label) {
		
		return context = new BranchExtensionContext();
	}
	
	@Override
	public void dispose() {
		
		context = null;
	}
	
	@Override
	public void initialize() {
		
	}

}
