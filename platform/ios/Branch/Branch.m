/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * @file   		Branch.m
 * @brief  		ActionScript Native Extension
 * @author 		Michael Archbold
 * @created		Jan 19, 2012
 * @copyright	http://distriqt.com/copyright/license.txt
 *
 */


#import "FlashRuntimeExtensions.h"
#import "BranchController.h"
#import "BranchEventDispatcher.h"

#import <CoreNativeExtension/CoreNativeExtension.h>


NSString * const Branch_VERSION = @"1.0";
NSString * const Branch_IMPLEMENTATION = @"iOS";

FREContext distriqt_branch_ctx = nil;
Boolean distriqt_branch_v = false;
BranchEventDispatcher* distriqt_branch_eventDispatcher = nil;
BranchController* distriqt_branch_controller = nil;


////////////////////////////////////////////////////////
//	ACTIONSCRIPT INTERFACE METHODS 
//

FREObject BranchVersion(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
	FREObject result = NULL;
    @autoreleasepool
    {
        result = [DTFREUtils newFREObjectFromString: Branch_VERSION];
    }
    return result;
}


FREObject BranchImplementation(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
	FREObject result = NULL;
    @autoreleasepool
    {
        result = [DTFREUtils newFREObjectFromString: Branch_IMPLEMENTATION];
    }
    return result;
}


FREObject BranchIsSupported(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
	FREObject result = NULL;
    @autoreleasepool
    {
        result = [DTFREUtils newFREObjectFromBoolean: true ];
    }
    return result;
}


FREObject BranchVV2( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    FREObject result = NULL;
    @autoreleasepool
    {
        NSString* developerKey = [DTFREUtils getFREObjectAsString: argv[0]];
        int extensionIdNumber  = [DTFREUtils getFREObjectAsInt: argv[1]];
        distriqt_branch_v = [DTExtensionBase v: developerKey identifier: extensionIdNumber];
        result = [DTFREUtils newFREObjectFromBoolean: distriqt_branch_v];
    }
    return result;
}

//
//
//  EXTENSION FUNCTIONALITY
//
//

FREObject BranchFunction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        if (distriqt_branch_v) // key check
        {
            // Functionality
        }
    }
    return result;
}



////////////////////////////////////////////////////////
// FRE CONTEXT 
//

void BranchContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{

    //
	//	Add the ACTIONSCRIPT interface
	
	static FRENamedFunction distriqt_branchFunctionMap[] =
    {
        MAP_FUNCTION( BranchVersion,          "version",          NULL ),
        MAP_FUNCTION( BranchImplementation,   "implementation",   NULL ),
        MAP_FUNCTION( BranchIsSupported,      "isSupported",      NULL ),
        MAP_FUNCTION( BranchVV2,              "vV2",              NULL )
    };
    
    *numFunctionsToTest = sizeof( distriqt_branchFunctionMap ) / sizeof( FRENamedFunction );
    *functionsToSet = distriqt_branchFunctionMap;
    
	
	//
	//	Store the global states
	
    distriqt_branch_ctx = ctx;
    distriqt_branch_v = false;
    
    distriqt_branch_eventDispatcher = [[BranchEventDispatcher alloc] init];
    distriqt_branch_eventDispatcher.context = distriqt_branch_ctx;
    
    distriqt_branch_controller = [[BranchController alloc] init];
    distriqt_branch_controller.delegate = distriqt_branch_eventDispatcher;

}


/**	
 *	The context finalizer is called when the extension's ActionScript code calls the ExtensionContext instance's dispose() method. 
 *	If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void BranchContextFinalizer(FREContext ctx) 
{
    if (distriqt_branch_controller != nil)
    {
        distriqt_branch_controller.delegate = nil;
        distriqt_branch_controller = nil;
    }
    
    if (distriqt_branch_eventDispatcher != nil)
    {
        distriqt_branch_eventDispatcher.context = nil;
        distriqt_branch_eventDispatcher = nil;
    }

	distriqt_branch_ctx = nil;
}


/**
 *	The extension initializer is called the first time the ActionScript
 *		side of the extension calls ExtensionContext.createExtensionContext() 
 *		for any context.
 */
void BranchExtInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) 
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &BranchContextInitializer;
	*ctxFinalizerToSet   = &BranchContextFinalizer;
} 


/**
 *	The extension finalizer is called when the runtime unloads the extension. However, it is not always called.
 */
void BranchExtFinalizer( void* extData ) 
{
	// Nothing to clean up.	
}

