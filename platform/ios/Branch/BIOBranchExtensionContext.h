//
//  BIOBranchExtensionContext.h
//  Branch
//
//  Created by Michael Archbold on 22/09/2015.
//  Copyright © 2025 Michael Archbold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BIOBranchContext.h"
#import "FlashRuntimeExtensions.h"


@interface BIOBranchExtensionContext : NSObject<BIOBranchContext>

@property FREContext context;

@end
