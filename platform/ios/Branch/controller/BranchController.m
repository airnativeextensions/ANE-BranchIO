//
//  BranchController.m
//  Branch
//
//  Created by Michael Archbold on 22/09/2015.
//  Copyright © 2015 distriqt. All rights reserved.
//

#import "BranchController.h"
#import "TypeConversion.h"

#import <Branch/Branch.h>


@implementation BranchController
{
    Branch *branch;
}

@synthesize context;

-(id) init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


- (void) initBranch:(BOOL) useTestKey
{
    Branch.useTestBranchKey = useTestKey;
    
    branch = [Branch getInstance];
    
    [branch initSessionWithLaunchOptions: @{}
              andRegisterDeepLinkHandler: ^(NSDictionary *params, NSError *error)
    {
        if (!error)
        {
            NSString *JSONString = [TypeConversion ConvertNSDictionaryToJSONString:params];
            
            [self.context dispatch:@"INIT_SUCCESSED" data:JSONString];
            
        }
        else
        {
            [self.context dispatch: @"INIT_FAILED" data: error.description];
        }
    }];
}


- (void) setIdentity:(NSString *) userId
{
    __weak typeof(self) weakSelf = self;
    [branch setIdentity: userId
           withCallback: ^(NSDictionary *params, NSError *error)
    {
        if (!error)
        {
            [weakSelf.context dispatch:@"SET_IDENTITY_SUCCESSED" data:@""];
        }
        else
        {
            [weakSelf.context dispatch:@"SET_IDENTITY_FAILED" data:error.description];
        }
    }];
}


- (void) getShortURL:(NSString *) json
             andTags:(NSArray *) tags
          andChannel:(NSString *) channel
          andFeature:(NSString *) feature
            andStage:(NSString *) stage
            andAlias:(NSString *) alias
             andType:(int) type
{
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;
    NSDictionary* params = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    if (jsonError)
    {
        [self.context dispatch: @"GET_SHORT_URL_FAILED" data:jsonError.description];
    }
    else
    {
        callbackWithUrl callback = ^(NSString *url, NSError *error)
        {
            if (!error)
            {
                [self.context dispatch:@"GET_SHORT_URL_SUCCESSED" data:url];
            }
            else
            {
                [self.context dispatch:@"GET_SHORT_URL_FAILED" data:error.description];
            }
        };
        
        if (alias.length != 0)
        {
            [branch getShortURLWithParams:params andTags:tags andChannel:channel andFeature:feature andStage:stage andAlias:alias andCallback:callback];
        }
        else if (type != -1)
        {
            [branch getShortURLWithParams:params andTags:tags andChannel:channel andFeature:feature andStage:stage andType:type andCallback:callback];
        }
        else
        {
            [branch getShortURLWithParams:params andTags:tags andChannel:channel andFeature:feature andStage:stage andCallback:callback];
        }
    }
}


- (void) logout
{
    [branch logout];
}


- (void) userCompletedAction:(NSString *) action withState:(NSString *) appState
{
    NSData *data = [appState dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;
    
    NSDictionary* params = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    if (!jsonError)
    {
        [branch userCompletedAction:action withState:params];
    }
}

- (NSString *) getLatestReferringParams
{
    NSDictionary* paramsDict = [branch getLatestReferringParams];
    return [TypeConversion ConvertNSDictionaryToJSONString: paramsDict];
}


- (NSString *) getFirstReferringParams
{
    NSDictionary* paramsDict = [branch getFirstReferringParams];
    return [TypeConversion ConvertNSDictionaryToJSONString: paramsDict];
}


- (void) getCredits:(NSString *) bucket
{
    [branch loadRewardsWithCallback:^(BOOL changed, NSError *error)
    {
        if (!error)
        {
            [self.context dispatch: @"GET_CREDITS_SUCCESSED"
                              data: [NSString stringWithFormat: @"%ld", (long) [self->branch getCreditsForBucket:bucket]]];
        }
        else
        {
            [self.context dispatch: @"GET_CREDITS_FAILED"
                              data: error.description];
        }
    }];
}


- (void) redeemRewards:(NSInteger) credits andBucket:(NSString *) bucket
{
    [branch redeemRewards:credits forBucket:bucket callback:^(BOOL changed, NSError *error)
    {
        if (!error)
        {
            [self.context dispatch:@"REDEEM_REWARDS_SUCCESSED" data:@""];
        }
        else
        {
            [self.context dispatch:@"REDEEM_REWARDS_FAILED" data:error.description];
        }
    }];
}


- (void) getCreditsHistory:(NSString *) bucket
{
    [branch getCreditHistoryForBucket:bucket andCallback:^(NSArray *list, NSError *error)
    {
        if (!error)
        {
            [self.context dispatch:@"GET_CREDITS_HISTORY_SUCCESSED" data:[[list valueForKey:@"description"] componentsJoinedByString:@""]];
        }
        else
        {
            [self.context dispatch:@"GET_CREDITS_HISTORY_FAILED" data:error.description];
        }
    }];
}

- (void) getReferralCode
{
//    [branch getPromoCodeWithCallback:^(NSDictionary *params, NSError *error) {
//
//        if (!error)
//            [self.context dispatch:@"GET_REFERRAL_CODE_SUCCESSED" data:[params objectForKey:@"promo_code"]];
//
//        else
//            [self.context dispatch:@"GET_REFERRAL_CODE_FAILED" data:error.description];
//    }];
}

- (void) createReferralCode:(NSString *)prefix amount:(NSInteger)amount expiration:(NSInteger)expiration bucket:(NSString *)bucket usageType:(NSInteger)usageType rewardLocation:(NSInteger)rewardLocation
{
//    [branch getPromoCodeWithPrefix:prefix amount:amount expiration:[NSDate dateWithTimeIntervalSince1970:expiration / 1000] bucket:bucket usageType:usageType rewardLocation:rewardLocation callback:^(NSDictionary *params, NSError *error) {
//
//        if (!error)
//            [self.context dispatch:@"CREATE_REFERRAL_CODE_SUCCESSED" data:[params objectForKey:@"promo_code"]];
//
//        else
//            [self.context dispatch:@"CREATE_REFERRAL_CODE_FAILED" data:error.description];
//    }];
}

- (void) validateReferralCode:(NSString *) code
{
//    [branch validatePromoCode:code callback:^(NSDictionary *params, NSError *error) {
//
//        if (!error) {
//
//            if ([code isEqualToString:[params objectForKey:@"promo_code"]])
//                [self.context dispatch:@"VALIDATE_REFERRAL_CODE_SUCCESSED" data:@""];
//
//            else
//                [self.context dispatch:@"VALIDATE_REFERRAL_CODE_FAILED" data:@"invalid (should never happen)"];
//
//        } else
//            [self.context dispatch:@"VALIDATE_REFERRAL_CODE_FAILED" data:error.description];
//    }];
}

- (void) applyReferralCode:(NSString *) code
{
//    [branch applyPromoCode:code callback:^(NSDictionary *params, NSError *error) {
//
//        if (!error) {
//
//            NSString *JSONString = [TypeConversion ConvertNSDictionaryToJSONString:params];
//
//            [self.context dispatch:@"APPLY_REFERRAL_CODE_SUCCESSED" data:JSONString];
//
//        } else
//            [self.context dispatch:@"APPLY_REFERRAL_CODE_FAILED" data:error.description];
//    }];
}




#pragma mark

//SEL selectorToOverride1 = @selector(application:openURL:sourceApplication:annotation:);
//SEL selectorToOverride2 = @selector(application:didFinishLaunchingWithOptions:);
//SEL selectorToOverride3 = @selector(application:continueUserActivity:restorationHandler:);
//
//
//bool applicationDidFinishLaunchingWithOptions(id self, SEL _cmd, UIApplication* application, NSDictionary* launchOptions) {
//    //NSLog(@"applicationDidFinishLaunchingWithOptions");
//
//    Branch *branch = [Branch getInstance];
//    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
//
//        if (!error) {
//
//            NSString *JSONString = [TypeConversion ConvertNSDictionaryToJSONString:params];
//
//            [branchHelpers dispatchEvent:@"INIT_SUCCESSED" withParams:JSONString];
//
//        } else {
//
//            [branchHelpers dispatchEvent:@"INIT_FAILED" withParams:error.description];
//        }
//    }];
//
//    return YES;
//}
//
//bool applicationOpenURLSourceApplication(id self, SEL _cmd, UIApplication* application, NSURL* url, NSString* sourceApplication, id annotation) {
//    //NSLog(@"applicationOpenURLSourceApplication");
//
//    // if handleDeepLink returns YES, and you registered a callback in initSessionAndRegisterDeepLinkHandler, the callback will be called with the data associated with the deep link
//    if (![[Branch getInstance] handleDeepLink:url]) {
//        // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
//    }
//
//    return YES;
//}
//
//bool applicationContinueUserActivity(id self, SEL _cmd, UIApplication* application, NSUserActivity* userActivity, id restorationHandler) {
//    //NSLog(@"applicationContinueUserActivity");
//
//    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
//
//    return handledByBranch;
//}






@end
