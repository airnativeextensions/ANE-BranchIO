//
//  BIOBranchController.m
//  Branch
//
//  Created by Michael Archbold on 22/09/2015.
//  Copyright © 2015 distriqt. All rights reserved.
//

#import "BIOBranchController.h"
#import "BIOTypeConversion.h"
#import "BIOBranchEvent.h"
#import "BIOBranchCreditsEvent.h"

#import <Branch/Branch.h>


@implementation BIOBranchController
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


-(void) initSession:(BIOBranchOptions*)options
{
    [context log: Branch_TAG message: @"BIOBranchController::initSession: %@", options.useTestKey ? @"true" : @"false"];
    if (options.useTestKey)
    {
        Branch.useTestBranchKey = YES;
    }
    if (options.delayInitToCheckForSearchAds)
    {
        [[Branch getInstance] delayInitToCheckForSearchAds];
    }
}


-(void) setIdentity:(NSString *) userId
{
    [context log: Branch_TAG message: @"BIOBranchController::setIdentity: %@", userId];
    __weak typeof(self) weakSelf = self;
    [[Branch getInstance] setIdentity: userId
                         withCallback: ^(NSDictionary *params, NSError *error)
    {
        if (!error)
        {
            [weakSelf.context dispatch: BIO_BRANCHEVENT_SET_IDENTITY_SUCCESS data:@""];
        }
        else
        {
            [weakSelf.context dispatch: BIO_BRANCHEVENT_SET_IDENTITY_FAILED data:error.description];
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
    [context log: Branch_TAG message: @"BIOBranchController::getShortURL"];
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
                [self.context dispatch: BIO_BRANCHEVENT_GET_SHORT_URL_SUCCESS
                                  data: url];
            }
            else
            {
                [self.context dispatch: BIO_BRANCHEVENT_GET_SHORT_URL_FAILED
                                  data: error.description];
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
    [context log: Branch_TAG message: @"BIOBranchController::logout"];
    [[Branch getInstance] logout];
}


-(NSString *) getLatestReferringParams
{
    [context log: Branch_TAG message: @"BIOBranchController::getLatestReferringParams"];
    NSDictionary* paramsDict = [[Branch getInstance] getLatestReferringParams];
    return [BIOTypeConversion ConvertNSDictionaryToJSONString: paramsDict];
}


-(NSString *) getFirstReferringParams
{
    [context log: Branch_TAG message: @"BIOBranchController::getFirstReferringParams"];
    NSDictionary* paramsDict = [[Branch getInstance] getFirstReferringParams];
    return [BIOTypeConversion ConvertNSDictionaryToJSONString: paramsDict];
}


-(void) handleDeepLink: (NSString*)link forceNewSession:(Boolean)forceNewSession
{
    @try
    {
        [context log: Branch_TAG message: @"BIOBranchController::handleDeepLink: %@" , link ];
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
    [context log: Branch_TAG message: @"BIOBranchController::userCompletedAction: %@ withState: %@", action, appState];
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
        [context log: Branch_TAG message: @"BIOBranchController::logEvent: %@" , eventJSONString ];
        
        NSData *data = [eventJSONString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        NSDictionary* eventDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (!jsonError)
        {
            NSString* eventName = [eventDict objectForKey: @"eventName"];
            
            BranchEvent* event;
            if ([eventDict objectForKey: @"isStandardEvent"])
            {
                [context log: Branch_TAG message: @"BIOBranchController::logEvent: standard" ];
                event = [BranchEvent standardEvent: eventName];
            }
            else
            {
                [context log: Branch_TAG message: @"BIOBranchController::logEvent: custom" ];
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
    [context log: Branch_TAG message: @"BIOBranchController::getCredits: %@", bucket];
    [[Branch getInstance] loadRewardsWithCallback:^(BOOL changed, NSError *error)
    {
        if (!error)
        {
            [self.context dispatch: BIO_BRANCHCREDITSEVENT_GET_CREDITS_SUCCESS
                              data: [NSString stringWithFormat: @"%ld", (long) [[Branch getInstance] getCreditsForBucket:bucket]]];
        }
        else
        {
            [self.context dispatch: BIO_BRANCHCREDITSEVENT_GET_CREDITS_FAILED
                              data: error.description];
        }
    }];
}


- (void) redeemRewards:(NSInteger) credits andBucket:(NSString *) bucket
{
    [context log: Branch_TAG message: @"BIOBranchController::redeemRewards: %d andBucket: %@", credits, bucket];
    [[Branch getInstance] redeemRewards:credits forBucket:bucket callback:^(BOOL changed, NSError *error)
    {
        if (!error)
        {
            [self.context dispatch: BIO_BRANCHCREDITSEVENT_REDEEM_REWARDS_SUCCESS
                              data: @""];
        }
        else
        {
            [self.context dispatch: BIO_BRANCHCREDITSEVENT_REDEEM_REWARDS_FAILED
                              data: error.description];
        }
    }];
}


- (void) getCreditsHistory:(NSString *) bucket
{
    [context log: Branch_TAG message: @"BIOBranchController::getCreditsHistory: %@", bucket];
    [[Branch getInstance] getCreditHistoryForBucket:bucket andCallback:^(NSArray *list, NSError *error)
    {
        if (!error)
        {
            [self.context dispatch: BIO_BRANCHCREDITSEVENT_GET_CREDITS_HISTORY_SUCCESS
                              data: [[list valueForKey:@"description"] componentsJoinedByString:@""]];
        }
        else
        {
            [self.context dispatch: BIO_BRANCHCREDITSEVENT_GET_CREDITS_HISTORY_FAILED
                              data: error.description];
        }
    }];
}





-(void) validateIntegration
{
    [context log: Branch_TAG message: @"BIOBranchController::validateConfiguration" ];
    [[Branch getInstance] validateSDKIntegration];
}




#pragma mark DTNotifications


-(void) didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [context log: Branch_TAG message: @"BIOBranchController::didFinishLaunchingWithOptions: %@", launchOptions];
    [[Branch getInstance] initSessionWithLaunchOptions: launchOptions
                            andRegisterDeepLinkHandler: ^(NSDictionary *params, NSError *error)
    {
		[self.context log: Branch_TAG message: @"BIOBranchController::didFinishLaunchingWithOptions: initSessionWithLaunchOptions: complete: %@ error: %@", params, error ];
		if (!error)
        {
            NSString *JSONString = [BIOTypeConversion ConvertNSDictionaryToJSONString:params];
            [self.context dispatch: BIO_BRANCHEVENT_INIT_SUCCESS data:JSONString];
        }
        else
        {
            [self.context dispatch: BIO_BRANCHEVENT_INIT_FAILED data:error.description];
        }
    }];
	
	
	//
	// Handle issue with launch not detecting urls, so manually send to Branch
	
	if (launchOptions != nil)
	{
		if ([launchOptions.allKeys containsObject:UIApplicationLaunchOptionsURLKey])
		{
			NSURL* url = [launchOptions objectForKey: UIApplicationLaunchOptionsURLKey];
			[[Branch getInstance] handleDeepLink: url];
		}
		else if ([launchOptions.allKeys containsObject:UIApplicationLaunchOptionsUserActivityDictionaryKey])
		{
			[self.context log: Branch_TAG message: @"BIOBranchController::didFinishLaunchingWithOptions: options contains UIApplicationLaunchOptionsUserActivityDictionaryKey" ];
			 
			NSDictionary* userActivityDictionary = [launchOptions objectForKey: UIApplicationLaunchOptionsUserActivityDictionaryKey];
			[self.context log: Branch_TAG message: @"BIOBranchController::didFinishLaunchingWithOptions: userActivityDictionary = %@", userActivityDictionary];
			 
			 
			NSUserActivity* userActivity = [userActivityDictionary objectForKey: @"UIApplicationLaunchOptionsUserActivityKey"];
			[self.context log: Branch_TAG message: @"BIOBranchController::didFinishLaunchingWithOptions: userActivity = %@", userActivity];
			
			[[Branch getInstance] continueUserActivity: userActivity];
		}
	}
	
}


-(void) openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [context log: Branch_TAG message: @"BIOBranchController::openURL: %@ sourceApplication: %@", url, sourceApplication];
    
    // if handleDeepLink returns YES, and you registered a callback in initSessionAndRegisterDeepLinkHandler,
    // the callback will be called with the data associated with the deep link

//    [[Branch getInstance] handleDeepLink:url];


	[[Branch getInstance] application: [UIApplication sharedApplication]
							  openURL: url
					sourceApplication: sourceApplication
						   annotation: annotation];
	

}


-(void) openURL:(NSURL *)url options: (NSDictionary*)options
{
    [context log: Branch_TAG message: @"BIOBranchController::openURL: %@", url];
//    [[Branch getInstance] handleDeepLink:url];

	[[Branch getInstance] application: [UIApplication sharedApplication]
							  openURL: url
							  options: options];
}


-(void) continueUserActivity: (NSUserActivity*)userActivity
{
    [context log: Branch_TAG message: @"BIOBranchController::continueUserActivity:" ];
//    BOOL handledByBranch =
    [[Branch getInstance] continueUserActivity:userActivity];
}




@end
