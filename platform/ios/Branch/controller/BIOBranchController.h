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

#import "BNCConfig.h"

@interface BIOBranchController : NSObject<DTNotificationsDelegate>

@property id<BIOBranchContext> context;

-(NSString*) version;

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
//  BRANCH UNIVERSAL OBJECTS
//

-(void) generateShortUrl: (NSString*)requestId buo: (NSDictionary*)buoProperties linkProperties:(NSDictionary*)linkProperties;



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
