//
//  BranchController.h
//  Branch
//
//  Created by Michael Archbold on 22/09/2015.
//  Copyright © 2015 distriqt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreNativeExtension/CoreNativeExtension.h>

#import "BranchOptions.h"
#import "BranchContext.h"


@interface BranchController : NSObject<DTNotificationsDelegate>

@property id<BranchContext> context;

-(void) initSession:(BranchOptions*)options;
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
