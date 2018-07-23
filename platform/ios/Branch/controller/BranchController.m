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
//    Branch *branch;
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
    [context log: Branch_TAG message: @"BranchController::initBranch: %@", useTestKey ? @"true" : @"false"];
    Branch.useTestBranchKey = useTestKey;
//    branch = [Branch getInstance];
    
//    [branch initSessionWithLaunchOptions: @{}
//              andRegisterDeepLinkHandler: ^(NSDictionary *params, NSError *error)
//    {
//        if (!error)
//        {
//            NSString *JSONString = [TypeConversion ConvertNSDictionaryToJSONString:params];
//
//            [self.context dispatch:@"INIT_SUCCESSED" data:JSONString];
//
//        }
//        else
//        {
//            [self.context dispatch: @"INIT_FAILED" data: error.description];
//        }
//    }];
}


- (void) setIdentity:(NSString *) userId
{
    [context log: Branch_TAG message: @"BranchController::setIdentity: %@", userId];
    __weak typeof(self) weakSelf = self;
    [[Branch getInstance] setIdentity: userId
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
    [context log: Branch_TAG message: @"BranchController::getShortURL"];
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
            [[Branch getInstance] getShortURLWithParams:params
                                                andTags:tags
                                             andChannel:channel
                                             andFeature:feature
                                               andStage:stage
                                               andAlias:alias
                                            andCallback:callback];
        }
        else if (type != -1)
        {
            [[Branch getInstance] getShortURLWithParams:params
                                                andTags:tags
                                             andChannel:channel
                                             andFeature:feature
                                               andStage:stage
                                                andType:type
                                            andCallback:callback];
        }
        else
        {
            [[Branch getInstance] getShortURLWithParams:params
                                                andTags:tags
                                             andChannel:channel
                                             andFeature:feature
                                               andStage:stage
                                            andCallback:callback];
        }
    }
}


- (void) logout
{
    [context log: Branch_TAG message: @"BranchController::logout"];
    [[Branch getInstance] logout];
}


- (void) userCompletedAction:(NSString *) action withState:(NSString *) appState
{
    [context log: Branch_TAG message: @"BranchController::userCompletedAction: %@ withState: %@", action, appState];
    NSData *data = [appState dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError;
    
    NSDictionary* params = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    
    if (!jsonError)
    {
        [[Branch getInstance] userCompletedAction:action withState:params];
    }
}

- (NSString *) getLatestReferringParams
{
    [context log: Branch_TAG message: @"BranchController::getLatestReferringParams"];
    NSDictionary* paramsDict = [[Branch getInstance] getLatestReferringParams];
    return [TypeConversion ConvertNSDictionaryToJSONString: paramsDict];
}


- (NSString *) getFirstReferringParams
{
    [context log: Branch_TAG message: @"BranchController::getFirstReferringParams"];
    NSDictionary* paramsDict = [[Branch getInstance] getFirstReferringParams];
    return [TypeConversion ConvertNSDictionaryToJSONString: paramsDict];
}


- (void) getCredits:(NSString *) bucket
{
    [context log: Branch_TAG message: @"BranchController::getCredits: %@", bucket];
    [[Branch getInstance] loadRewardsWithCallback:^(BOOL changed, NSError *error)
    {
        if (!error)
        {
            [self.context dispatch: @"GET_CREDITS_SUCCESSED"
                              data: [NSString stringWithFormat: @"%ld", (long) [[Branch getInstance] getCreditsForBucket:bucket]]];
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
    [context log: Branch_TAG message: @"BranchController::redeemRewards: %d andBucket: %@", credits, bucket];
    [[Branch getInstance] redeemRewards:credits forBucket:bucket callback:^(BOOL changed, NSError *error)
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
    [context log: Branch_TAG message: @"BranchController::getCreditsHistory: %@", bucket];
    [[Branch getInstance] getCreditHistoryForBucket:bucket andCallback:^(NSArray *list, NSError *error)
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
//    [[Branch getInstance] getPromoCodeWithCallback:^(NSDictionary *params, NSError *error) {
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
//    [[Branch getInstance] getPromoCodeWithPrefix:prefix amount:amount expiration:[NSDate dateWithTimeIntervalSince1970:expiration / 1000] bucket:bucket usageType:usageType rewardLocation:rewardLocation callback:^(NSDictionary *params, NSError *error) {
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
//    [[Branch getInstance] validatePromoCode:code callback:^(NSDictionary *params, NSError *error) {
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
//    [[Branch getInstance] applyPromoCode:code callback:^(NSDictionary *params, NSError *error) {
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




#pragma mark DTNotifications


-(void) didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [context log: Branch_TAG message: @"BranchController::didFinishLaunchingWithOptions: %@", launchOptions];
    [[Branch getInstance] initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error)
    {
        if (!error)
        {
            NSString *JSONString = [TypeConversion ConvertNSDictionaryToJSONString:params];
            [self.context dispatch:@"INIT_SUCCESSED" data:JSONString];
        }
        else
        {
            [self.context dispatch:@"INIT_FAILED" data:error.description];
        }
    }];
}

-(void) openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [context log: Branch_TAG message: @"BranchController::openURL: %@ sourceApplication: %@", url, sourceApplication];
    
    // if handleDeepLink returns YES, and you registered a callback in initSessionAndRegisterDeepLinkHandler,
    // the callback will be called with the data associated with the deep link

    [[Branch getInstance] handleDeepLink:url];

}

-(void) openURL:(NSURL *)url options: (NSDictionary*)options
{
    [context log: Branch_TAG message: @"BranchController::openURL: %@", url];
    [[Branch getInstance] handleDeepLink:url];
}

-(void) continueUserActivity: (NSUserActivity*)userActivity
{
    [context log: Branch_TAG message: @"BranchController::continueUserActivity:" ];
//    BOOL handledByBranch =
    [[Branch getInstance] continueUserActivity:userActivity];
}




@end
