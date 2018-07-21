//
//  BranchController.h
//  Branch
//
//  Created by Michael Archbold on 22/09/2015.
//  Copyright © 2015 distriqt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BranchContext.h"


@interface BranchController : NSObject

@property id<BranchContext> context;

- (void) initBranch:(BOOL) useTestKey;
- (void) setIdentity:(NSString *) userId;
- (void) logout;

- (NSString*) getLatestReferringParams;
- (NSString*) getFirstReferringParams;
- (void) userCompletedAction:(NSString *) action withState:(NSString *) appState;
- (void) getCredits:(NSString *) bucket;
- (void) redeemRewards:(NSInteger) credits andBucket:(NSString *) bucket;
- (void) getCreditsHistory:(NSString *) bucket;

- (void) getShortURL:(NSString *) json andTags:(NSArray *) tags andChannel:(NSString *) channel andFeature:(NSString *) feature andStage:(NSString *) stage andAlias:(NSString *) alias andType:(int) type;

- (void) getReferralCode;
- (void) createReferralCode:(NSString *)prefix amount:(NSInteger)amount expiration:(NSInteger)expiration bucket:(NSString *)bucket usageType:(NSInteger)usageType rewardLocation:(NSInteger)rewardLocation;
- (void) validateReferralCode:(NSString *) code;
- (void) applyReferralCode:(NSString *) code;


@end
