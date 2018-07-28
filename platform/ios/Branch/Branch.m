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
#import "BranchExtensionContext.h"

#import <CoreNativeExtension/CoreNativeExtension.h>


NSString * const Branch_VERSION = @"1.0";
NSString * const Branch_IMPLEMENTATION = @"iOS";

FREContext branch_ctx = nil;
BranchExtensionContext* branch_extensionContext = nil;
BranchController* branch_controller = nil;
DTNotifications* branch_notifications = nil;

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



//
//
//  EXTENSION FUNCTIONALITY
//
//

FREObject Branch_initSession(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        Boolean useTestKey = [DTFREUtils getFREObjectAsBoolean: argv[0]];
        
        [branch_controller initSession: useTestKey];
        
        [branch_notifications checkLaunchOptions];
    }
    return result;
}

FREObject Branch_setIdentity(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        NSString* userId = [DTFREUtils getFREObjectAsString: argv[0]];
        
        [branch_controller setIdentity: userId];
    }
    return result;
}

FREObject Branch_logout(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        [branch_controller logout];
    }
    return result;
}

FREObject Branch_getLatestReferringParams(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        NSString* params = [branch_controller getLatestReferringParams];
        result = [DTFREUtils newFREObjectFromString: params];
    }
    return result;
}

FREObject Branch_handleDeepLink(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        NSString* link = [DTFREUtils getFREObjectAsString: argv[0]];
        Boolean forceNewSession = [DTFREUtils getFREObjectAsBoolean: argv[0]];
        
        [branch_controller handleDeepLink: link
                          forceNewSession: forceNewSession];
    }
    return result;
}


FREObject Branch_userCompletedAction(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        NSString* action = [DTFREUtils getFREObjectAsString: argv[0]];
        NSString* appState = [DTFREUtils getFREObjectAsString: argv[1]];
        
        [branch_controller userCompletedAction: action withState: appState];
    }
    return result;
}

FREObject Branch_logEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        NSString* eventJSONString = [DTFREUtils getFREObjectAsString: argv[0]];
        
        Boolean success = [branch_controller logEvent: eventJSONString];
    
        result = [DTFREUtils newFREObjectFromBoolean: success];
    }
    return result;
}



FREObject Branch_getFirstReferringParams(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        NSString* params = [branch_controller getFirstReferringParams];
        result = [DTFREUtils newFREObjectFromString: params];
    }
    return result;
}

FREObject Branch_getCredits(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        NSString* bucket = [DTFREUtils getFREObjectAsString: argv[0]];
        
        [branch_controller getCredits: bucket];
    }
    return result;
}

FREObject Branch_redeemRewards(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        int credits = [DTFREUtils getFREObjectAsInt: argv[0]];
        NSString* bucket = [DTFREUtils getFREObjectAsString: argv[1]];
        
        [branch_controller redeemRewards: credits
                               andBucket: bucket];
    }
    return result;
}

FREObject Branch_getCreditsHistory(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        NSString* bucket = [DTFREUtils getFREObjectAsString: argv[0]];
        
        [branch_controller getCreditsHistory: bucket];
    }
    return result;
}


FREObject Branch_getShortUrl(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject result = NULL;
    @autoreleasepool
    {
        NSArray* tags = [DTFREUtils getFREObjectAsArrayOfStrings: argv[0]];
        NSString* channel = [DTFREUtils getFREObjectAsString: argv[1]];
        NSString* feature = [DTFREUtils getFREObjectAsString: argv[2]];
        NSString* stage = [DTFREUtils getFREObjectAsString: argv[3]];
        NSString* json = [DTFREUtils getFREObjectAsString: argv[4]];
        NSString* alias = [DTFREUtils getFREObjectAsString: argv[5]];
        int type = [DTFREUtils getFREObjectAsInt: argv[6]];
        
        [branch_controller getShortURL: json
                               andTags: tags
                            andChannel: channel
                            andFeature: feature
                              andStage: stage
                              andAlias: alias
                               andType: type ];
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
        MAP_FUNCTION( BranchVersion,                    "version",                  NULL ),
        MAP_FUNCTION( BranchImplementation,             "implementation",           NULL ),
        MAP_FUNCTION( BranchIsSupported,                "isSupported",              NULL ),
        
        MAP_FUNCTION( Branch_initSession,               "initSession",              NULL ),
        MAP_FUNCTION( Branch_setIdentity,               "setIdentity",              NULL ),
        MAP_FUNCTION( Branch_logout,                    "logout",                   NULL ),
        
        MAP_FUNCTION( Branch_getLatestReferringParams,  "getLatestReferringParams", NULL ),
        MAP_FUNCTION( Branch_getFirstReferringParams,   "getFirstReferringParams",  NULL ),
        MAP_FUNCTION( Branch_handleDeepLink,            "handleDeepLink",           NULL ),

        MAP_FUNCTION( Branch_userCompletedAction,       "userCompletedAction",      NULL ),
        MAP_FUNCTION( Branch_logEvent,                  "logEvent",                 NULL ),

        MAP_FUNCTION( Branch_getCredits,                "getCredits",               NULL ),
        MAP_FUNCTION( Branch_redeemRewards,             "redeemRewards",            NULL ),
        MAP_FUNCTION( Branch_getCreditsHistory,         "getCreditsHistory",        NULL ),
        
        MAP_FUNCTION( Branch_getShortUrl,               "getShortUrl",              NULL ),
        
        
    };
    
    *numFunctionsToTest = sizeof( distriqt_branchFunctionMap ) / sizeof( FRENamedFunction );
    *functionsToSet = distriqt_branchFunctionMap;
    
	
	//
	//	Store the global states
	
    branch_ctx = ctx;
    
    branch_extensionContext = [[BranchExtensionContext alloc] init];
    branch_extensionContext.context = branch_ctx;
    
    branch_controller = [[BranchController alloc] init];
    branch_controller.context = branch_extensionContext;
    
    branch_notifications = [[DTNotifications alloc] init];
    branch_notifications.delegate = branch_controller;
}


/**	
 *	The context finalizer is called when the extension's ActionScript code calls the ExtensionContext instance's dispose() method. 
 *	If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void BranchContextFinalizer(FREContext ctx) 
{
    if (branch_notifications != nil)
    {
        [branch_notifications removeObservers];
        branch_notifications.delegate = nil;
        branch_notifications = nil;
    }
    if (branch_controller != nil)
    {
        branch_controller.context = nil;
        branch_controller = nil;
    }
    if (branch_extensionContext != nil)
    {
        branch_extensionContext.context = nil;
        branch_extensionContext = nil;
    }
	branch_ctx = nil;
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

