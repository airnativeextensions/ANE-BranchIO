//
//  BranchExtensionContext.h
//  Branch
//
//  Created by Michael Archbold on 22/09/2015.
//  Copyright © 2015 distriqt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BranchContext.h"
#import "FlashRuntimeExtensions.h"


@interface BranchExtensionContext : NSObject<BranchContext>

@property FREContext context;

@end
