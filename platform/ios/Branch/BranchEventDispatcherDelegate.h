//
//  BranchEventDispatcherDelegate.h
//  Branch
//
//  Created by Michael Archbold on 23/09/2015.
//  Copyright © 2015 distriqt. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BranchEventDispatcherDelegate <NSObject>

-(void) log: (NSString*) tag message: (NSString*) message, ...;

-(void) dispatch: (NSString*) code data: (NSString*) data;

@optional

@end
