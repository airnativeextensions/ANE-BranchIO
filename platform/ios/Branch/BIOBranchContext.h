//
//  BIOBranchContext.h
//  Branch
//
//  Created by Michael Archbold on 23/09/2015.
//  Copyright © 2025 Michael Archbold. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BIOBranchContext <NSObject>

-(void) log: (NSString*) tag message: (NSString*) message, ...;

-(void) dispatch: (NSString*) code data: (NSString*) data;

@optional

@end
