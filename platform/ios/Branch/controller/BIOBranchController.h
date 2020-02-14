//
//  BIOBranchController.h
//  Branch
//
//  Created by Michael Archbold on 22/09/2015.
//  Copyright © 2015 distriqt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreNativeExtension/CoreNativeExtension.h>

#import "BIOBranchOptions.h"
#import "BIOBranchContext.h"


@interface BIOBranchController : NSObject<DTNotificationsDelegate>

@property id<BIOBranchContext> context;

-(void) initSession:(BIOBranchOptions*)options;
-(void) setIdentity:(NSString *) userId;
-(void) logout;


-(NSString*) getLatestReferringParams;
-(NSString*) getFirstReferringParams;
-(void) handleDeepLink: (NSString*)link forceNewSession:(Boolean)forceNewSession;


-(void) userCompletedAction:(NSString *) action withState:(NSString *) appState;
-(Boolean) logEvent: (NSString*)eventJSONString;


-(void) getCredits:(NSString *) bucket;
-(void) redeemRewards:(NSInteger) credits andBucket:(NSString *) bucket;
-(void) getCreditsHistory:(NSString *) bucket;


-(void) validateIntegration;


//
//  LEGACY
//

-(void) getShortURL:(NSString *) json
            andTags:(NSArray *) tags
         andChannel:(NSString *) channel
         andFeature:(NSString *) feature
           andStage:(NSString *) stage
           andAlias:(NSString *) alias
            andType:(int) type;

@end
