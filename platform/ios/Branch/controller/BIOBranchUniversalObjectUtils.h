//
//  BIOBranchUniversalObjectUtils.h
//  Branch
//
//  Created by Michael Archbold on 22/9/20.
//  Copyright © 2020 distriqt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Branch/Branch.h>


NS_ASSUME_NONNULL_BEGIN

@interface BIOBranchUniversalObjectUtils : NSObject


+(BranchLinkProperties*) linkPropertiesFromDict: (NSDictionary*)properties;

+(BranchUniversalObject*) buoFromDict: (NSDictionary*)properties;


@end

NS_ASSUME_NONNULL_END
