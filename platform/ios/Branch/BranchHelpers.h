//
//  BranchHelpers.h
//  BranchIosExtension
//
//  Created by Aymeric Lamboley on 13/04/2015.
//  Copyright (c) 2015 Pawprint Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashRuntimeExtensions.h"
#import <Branch/Branch.h>

@interface BranchHelpers : NSObject {
    
    FREContext ctx;
    Branch *branch;
}

- (id) initWithContext:(FREContext) context;

- (void) initBranch:(BOOL) useTestKey;
- (void) setIdentity:(NSString *) userId;
- (void) getShortURL:(NSString *) json andTags:(NSArray *) tags andChannel:(NSString *) channel andFeature:(NSString *) feature andStage:(NSString *) stage andAlias:(NSString *) alias andType:(int) type;
- (void) logout;

- (NSDictionary *) getLatestReferringParams;
- (NSDictionary *) getFirstReferringParams;
- (void) userCompletedAction:(NSString *) action withState:(NSString *) appState;
- (void) getCredits:(NSString *) bucket;
- (void) redeemRewards:(NSInteger) credits andBucket:(NSString *) bucket;
- (void) getCreditsHistory:(NSString *) bucket;
- (void) getReferralCode;
- (void) createReferralCode:(NSString *)prefix amount:(NSInteger)amount expiration:(NSInteger)expiration bucket:(NSString *)bucket usageType:(NSInteger)usageType rewardLocation:(NSInteger)rewardLocation;
- (void) validateReferralCode:(NSString *) code;
- (void) applyReferralCode:(NSString *) code;

- (void) dispatchEvent:(NSString *) event withParams:(NSString * ) params;

@end
