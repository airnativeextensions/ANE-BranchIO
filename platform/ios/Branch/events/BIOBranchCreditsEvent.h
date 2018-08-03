//
//  BIOBranchCreditsEvent.h
//  Branch
//
//  Created by Michael Archbold on 3/8/18.
//  Copyright © 2018 distriqt. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BIO_BRANCHCREDITSEVENT_GET_CREDITS_SUCCESS @"getcredits:success"
#define BIO_BRANCHCREDITSEVENT_GET_CREDITS_FAILED @"getcredits:failed"
#define BIO_BRANCHCREDITSEVENT_REDEEM_REWARDS_SUCCESS @"redeemrewards:success"
#define BIO_BRANCHCREDITSEVENT_REDEEM_REWARDS_FAILED @"redeemrewards:failed"
#define BIO_BRANCHCREDITSEVENT_GET_CREDITS_HISTORY_SUCCESS @"getcreditshistory:success"
#define BIO_BRANCHCREDITSEVENT_GET_CREDITS_HISTORY_FAILED @"getcreditshistory:failed"


@interface BIOBranchCreditsEvent : NSObject

@end
