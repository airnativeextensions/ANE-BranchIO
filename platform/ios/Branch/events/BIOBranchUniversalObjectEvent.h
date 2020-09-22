//
//  BIOBranchUniversalObjectEvent.h
//  Branch
//
//  Created by Michael Archbold on 21/9/20.
//  Copyright © 2020 distriqt. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define BIOBRANCHUNIVERSALOBJECTEVENT_GENERATE_SHORT_URL_SUCCESS @"generateShortUrl:success"
#define BIOBRANCHUNIVERSALOBJECTEVENT_GENERATE_SHORT_URL_FAILED @"generateShortUrl:failed"

@interface BIOBranchUniversalObjectEvent : NSObject


+(NSString*) formatForEvent: (NSString*)identifier requestId: (NSString*)requestId url:(NSString*)url error:(NSError*)error;


@end

NS_ASSUME_NONNULL_END
