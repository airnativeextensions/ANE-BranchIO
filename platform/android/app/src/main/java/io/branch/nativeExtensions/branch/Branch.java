/**
 * @author Michael Archbold (https://github.com/marchbold)
 * @created 27/1/2025
 */
package io.branch.nativeExtensions.branch;

import com.distriqt.core.utils.IExtensionContext;

import io.branch.referral.BuildConfig;

public class Branch
{
	public static final String VERSION        = BuildConfig.VERSION_NAME;
	public static final String IMPLEMENTATION = "Android";
	public static final String ID             = "io.branch.nativeExtensions.Branch";

	public static IExtensionContext context;

}
