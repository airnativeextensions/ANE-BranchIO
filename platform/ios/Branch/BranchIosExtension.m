//
//  BranchIosExtension.m
//  BranchIosExtension
//
//  Created by Aymeric Lamboley on 08/04/2015.
//  Copyright (c) 2015 Pawprint Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "FlashRuntimeExtensions.h"

#import "TypeConversion.h"
#import "BranchHelpers.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }


TypeConversion* typeConverter;
BranchHelpers* branchHelpers;

DEFINE_ANE_FUNCTION(init) {
    
    uint32_t useTestKey;
    FREGetObjectAsBool(argv[0], &useTestKey);
    
    [branchHelpers initBranch:useTestKey];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(setIdentity) {
    
    NSString* userId;
    [typeConverter FREGetObject:argv[0] asString:&userId];
    
    [branchHelpers setIdentity:userId];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(getShortUrl) {
    
    NSMutableSet* tags;
    [typeConverter FREGetObject:argv[0] asSetOfStrings:&tags];
    
    NSString* channel;
    [typeConverter FREGetObject:argv[1] asString:&channel];
    
    NSString* feature;
    [typeConverter FREGetObject:argv[2] asString:&feature];
    
    NSString* stage;
    [typeConverter FREGetObject:argv[3] asString:&stage];
    
    NSString* json;
    [typeConverter FREGetObject:argv[4] asString:&json];
    
    NSString* alias;
    [typeConverter FREGetObject:argv[5] asString:&alias];
    
    int32_t type;
    FREGetObjectAsInt32(argv[6], &type);
    
    [branchHelpers getShortURL:json andTags:[tags allObjects] andChannel:channel andFeature:feature andStage:stage andAlias:alias andType:type];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(logout) {
    
    [branchHelpers logout];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(userCompletedAction) {
    
    NSString* action;
    [typeConverter FREGetObject:argv[0] asString:&action];
    
    NSString* appState;
    [typeConverter FREGetObject:argv[1] asString:&appState];
    
    [branchHelpers userCompletedAction:action withState:appState];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(getLatestReferringParams) {
    
    NSDictionary *sessionParams = [branchHelpers getLatestReferringParams];
    NSString *JSONString = [TypeConversion ConvertNSDictionaryToJSONString:sessionParams];

    FREObject retStr;
    [typeConverter FREGetString:JSONString asObject:&retStr];

    return retStr;
}

DEFINE_ANE_FUNCTION(getFirstReferringParams) {
    
    NSDictionary *installParams = [branchHelpers getFirstReferringParams];
    NSString *JSONString = [TypeConversion ConvertNSDictionaryToJSONString:installParams];
    
    FREObject retStr;
    [typeConverter FREGetString:JSONString asObject:&retStr];
    
    return retStr;
}

DEFINE_ANE_FUNCTION(getCredits) {
    
    NSString* bucket;
    [typeConverter FREGetObject:argv[0] asString:&bucket];
    
    [branchHelpers getCredits:bucket];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(redeemRewards) {
    
    int32_t credits;
    FREGetObjectAsInt32(argv[0], &credits);
    
    NSString* bucket;
    [typeConverter FREGetObject:argv[1] asString:&bucket];
    
    [branchHelpers redeemRewards:credits andBucket:bucket];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(getCreditsHistory) {
    
    NSString* bucket;
    [typeConverter FREGetObject:argv[0] asString:&bucket];
    
    [branchHelpers getCreditsHistory:bucket];
    
    return  NULL;
}

DEFINE_ANE_FUNCTION(getReferralCode) {
    
    [branchHelpers getReferralCode];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(createReferralCode) {
    
    NSString* prefix;
    [typeConverter FREGetObject:argv[0] asString:&prefix];
    
    int32_t amount;
    FREGetObjectAsInt32(argv[1], &amount);
    
    int32_t expiration;
    FREGetObjectAsInt32(argv[2], &expiration);
    
    NSString* bucket;
    [typeConverter FREGetObject:argv[3] asString:&bucket];
    
    int32_t type;
    FREGetObjectAsInt32(argv[4], &type);
    
    int32_t rewardLocation;
    FREGetObjectAsInt32(argv[5], &rewardLocation);
    
    [branchHelpers createReferralCode:prefix amount:amount expiration:expiration bucket:bucket usageType:type rewardLocation:rewardLocation];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(validateReferralCode) {
    
    NSString* code;
    [typeConverter FREGetObject:argv[0] asString:&code];
    
    [branchHelpers validateReferralCode:code];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(applyReferralCode) {
    
    NSString* code;
    [typeConverter FREGetObject:argv[0] asString:&code];
    
    [branchHelpers applyReferralCode:code];
    
    return NULL;
}

bool applicationDidFinishLaunchingWithOptions(id self, SEL _cmd, UIApplication* application, NSDictionary* launchOptions) {
    //NSLog(@"applicationDidFinishLaunchingWithOptions");
    
    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        
        if (!error) {
            
            NSString *JSONString = [TypeConversion ConvertNSDictionaryToJSONString:params];
            
            [branchHelpers dispatchEvent:@"INIT_SUCCESSED" withParams:JSONString];
            
        } else {
            
            [branchHelpers dispatchEvent:@"INIT_FAILED" withParams:error.description];
        }
    }];
    
    return YES;
}

bool applicationOpenURLSourceApplication(id self, SEL _cmd, UIApplication* application, NSURL* url, NSString* sourceApplication, id annotation) {
    //NSLog(@"applicationOpenURLSourceApplication");
    
    // if handleDeepLink returns YES, and you registered a callback in initSessionAndRegisterDeepLinkHandler, the callback will be called with the data associated with the deep link
    if (![[Branch getInstance] handleDeepLink:url]) {
        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
    }
    
    return YES;
}

bool applicationContinueUserActivity(id self, SEL _cmd, UIApplication* application, NSUserActivity* userActivity, id restorationHandler) {
    //NSLog(@"applicationContinueUserActivity");
    
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    
    return handledByBranch;
}

void BranchContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    Class objectClass = object_getClass(delegate);
    
    NSString *newClassName = [NSString stringWithFormat:@"Custom_%@", NSStringFromClass(objectClass)];
    Class  modDelegate = NSClassFromString(newClassName);
    
    if (modDelegate == nil) {
        
        modDelegate = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
        
        SEL selectorToOverride1 = @selector(application:openURL:sourceApplication:annotation:);
        SEL selectorToOverride2 = @selector(application:didFinishLaunchingWithOptions:);
        SEL selectorToOverride3 = @selector(application:continueUserActivity:restorationHandler:);
        
        Method m1 = class_getInstanceMethod(objectClass, selectorToOverride1);
        Method m2 = class_getInstanceMethod(objectClass, selectorToOverride2);
        Method m3 = class_getInstanceMethod(objectClass, selectorToOverride3);
        
        class_addMethod(modDelegate, selectorToOverride1, (IMP)applicationOpenURLSourceApplication, method_getTypeEncoding(m1));
        class_addMethod(modDelegate, selectorToOverride2, (IMP)applicationDidFinishLaunchingWithOptions, method_getTypeEncoding(m2));
        class_addMethod(modDelegate, selectorToOverride3, (IMP)applicationContinueUserActivity, method_getTypeEncoding(m3));
        
        objc_registerClassPair(modDelegate);
    }
    
    object_setClass(delegate, modDelegate);
    
    static FRENamedFunction functionMap[] = {
        MAP_FUNCTION(init, NULL),
        MAP_FUNCTION(setIdentity, NULL),
        MAP_FUNCTION(getShortUrl, NULL),
        MAP_FUNCTION(logout, NULL),
        MAP_FUNCTION(userCompletedAction, NULL),
        MAP_FUNCTION(getLatestReferringParams, NULL),
        MAP_FUNCTION(getFirstReferringParams, NULL),
        MAP_FUNCTION(getCredits, NULL),
        MAP_FUNCTION(redeemRewards, NULL),
        MAP_FUNCTION(getCreditsHistory, NULL),
        MAP_FUNCTION(getReferralCode, NULL),
        MAP_FUNCTION(createReferralCode, NULL),
        MAP_FUNCTION(validateReferralCode, NULL),
        MAP_FUNCTION(applyReferralCode, NULL)
    };
    
    *numFunctionsToSet = sizeof( functionMap ) / sizeof( FRENamedFunction );
    *functionsToSet = functionMap;
    
    typeConverter = [[TypeConversion alloc] init];
    branchHelpers = [[BranchHelpers alloc] initWithContext:ctx];
}

void BranchContextFinalizer(FREContext ctx) {
    return;
}

void BranchExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    
    extDataToSet = NULL;
    *ctxInitializerToSet = &BranchContextInitializer;
    *ctxFinalizerToSet = &BranchContextFinalizer;
}

void BranchExtensionFinalizer() {
    return;
}