//
//  BranchController.h
//  Branch
//
//  Created by Michael Archbold on 22/09/2015.
//  Copyright © 2015 distriqt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BranchEventDispatcherDelegate.h"


@interface BranchController : NSObject

@property id<BranchEventDispatcherDelegate> delegate;


@end
