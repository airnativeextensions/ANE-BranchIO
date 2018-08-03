//
//  BIOBranchEvent.h
//  Branch
//
//  Created by Michael Archbold on 3/8/18.
//  Copyright © 2018 distriqt. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BIO_BRANCHEVENT_INIT_SUCCESS @"init:success"
#define BIO_BRANCHEVENT_INIT_FAILED @"init:failed"
#define BIO_BRANCHEVENT_SET_IDENTITY_SUCCESS @"setidentity:success"
#define BIO_BRANCHEVENT_SET_IDENTITY_FAILED @"setidentity:failed"
#define BIO_BRANCHEVENT_GET_SHORT_URL_SUCCESS @"getshorturl:success"
#define BIO_BRANCHEVENT_GET_SHORT_URL_FAILED @"getshorturl:failed"


@interface BIOBranchEvent : NSObject

+(NSString*) formatForEvent;

@end
