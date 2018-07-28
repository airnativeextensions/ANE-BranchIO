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


-(void) initSession:(BOOL)useTestKey
{
    [context log: Branch_TAG message: @"BranchController::initSession: %@", useTestKey ? @"true" : @"false"];
    Branch.useTestBranchKey = useTestKey;
}


-(void) setIdentity:(NSString *) userId
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


-(void) getShortURL:(NSString *) json
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


-(void) logout
{
    [context log: Branch_TAG message: @"BranchController::logout"];
    [[Branch getInstance] logout];
}


-(NSString *) getLatestReferringParams
{
    [context log: Branch_TAG message: @"BranchController::getLatestReferringParams"];
    NSDictionary* paramsDict = [[Branch getInstance] getLatestReferringParams];
    return [TypeConversion ConvertNSDictionaryToJSONString: paramsDict];
}


-(NSString *) getFirstReferringParams
{
    [context log: Branch_TAG message: @"BranchController::getFirstReferringParams"];
    NSDictionary* paramsDict = [[Branch getInstance] getFirstReferringParams];
    return [TypeConversion ConvertNSDictionaryToJSONString: paramsDict];
}


-(void) handleDeepLink: (NSString*)link forceNewSession:(Boolean)forceNewSession
{
    @try
    {
        [context log: Branch_TAG message: @"BranchController::handleDeepLink: %@" , link ];
        if (forceNewSession)
        {
            [[Branch getInstance] handleDeepLinkWithNewSession: [NSURL URLWithString: link]];
        }
        else
        {
            [[Branch getInstance] handleDeepLink: [NSURL URLWithString: link]];
        }
    }
    @catch (NSException* e)
    {
    }
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


-(Boolean) logEvent: (NSString*)eventJSONString
{
    @try
    {
        [context log: Branch_TAG message: @"BranchController::logEvent: %@" , eventJSONString ];
        
        NSData *data = [eventJSONString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        NSDictionary* eventDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (!jsonError)
        {
            NSString* eventName = [eventDict objectForKey: @"eventName"];
            
            BranchEvent* event;
            if ([eventDict objectForKey: @"isStandardEvent"])
            {
                [context log: Branch_TAG message: @"BranchController::logEvent: standard" ];
                event = [BranchEvent standardEvent: eventName];
            }
            else
            {
                [context log: Branch_TAG message: @"BranchController::logEvent: custom" ];
                event = [BranchEvent customEventWithName: eventName];
            }
            
            for (NSString* key in eventDict)
            {
                if ([key isEqualToString: @"transaction_id"])
                {
                    event.transactionID = [eventDict objectForKey: key];
                }
                else if ([key isEqualToString: @"currency"])
                {
                    event.currency = [eventDict objectForKey: key];
                }
                else if ([key isEqualToString: @"revenue"])
                {
                    event.revenue = [eventDict objectForKey: key];
                }
                else if ([key isEqualToString: @"shipping"])
                {
                    event.shipping = [eventDict objectForKey: key];
                }
                else if ([key isEqualToString: @"tax"])
                {
                    event.tax = [eventDict objectForKey: key];
                }
                else if ([key isEqualToString: @"coupon"])
                {
                    event.coupon = [eventDict objectForKey: key];
                }
                else if ([key isEqualToString: @"affiliation"])
                {
                    event.affiliation = [eventDict objectForKey: key];
                }
                else if ([key isEqualToString: @"description"])
                {
                    event.eventDescription = [eventDict objectForKey: key];
                }
                else if ([key isEqualToString: @"search_query"])
                {
                    event.searchQuery = [eventDict objectForKey: key];
                }
                else if ([key isEqualToString: @"customData"])
                {
                    event.customData = [eventDict objectForKey: key];
                }
            }
            
            [event logEvent];
            
            return true;
        }
        
    }
    @catch (NSException* e)
    {
    }
    return false;
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








#pragma mark DTNotifications


-(void) didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [context log: Branch_TAG message: @"BranchController::didFinishLaunchingWithOptions: %@", launchOptions];
    [[Branch getInstance] initSessionWithLaunchOptions: launchOptions
                            andRegisterDeepLinkHandler: ^(NSDictionary *params, NSError *error)
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
