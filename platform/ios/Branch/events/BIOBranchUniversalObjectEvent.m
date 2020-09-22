//
//  BIOBranchUniversalObjectEvent.m
//  Branch
//
//  Created by Michael Archbold on 21/9/20.
//  Copyright © 2020 distriqt. All rights reserved.
//

#import "BIOBranchUniversalObjectEvent.h"

@implementation BIOBranchUniversalObjectEvent


+(NSString*) formatForEvent: (NSString*)identifier requestId: (NSString*)requestId url:(NSString*)url error:(NSError*)error
{
    @try
    {
        NSMutableDictionary* eventDict = [[NSMutableDictionary alloc] init];
        
        [eventDict setObject: identifier forKey: @"identifier"];
        [eventDict setObject: requestId forKey: @"requestId"];
        
        if (url != nil)
        {
            [eventDict setObject: url forKey: @"url"];
        }
        
        if (error != nil)
        {
            NSMutableDictionary* errorDict = [[NSMutableDictionary alloc] init];
            [errorDict setObject: error.localizedDescription forKey: @"message"];
            [errorDict setObject: [NSNumber numberWithInteger: error.code] forKey: @"errorCode"];

            [eventDict setObject: errorDict forKey: error];
        }
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject: eventDict options: 0 error: nil];
        return [[NSString alloc] initWithData: jsonData encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception)
    {
    }
    return @"{}";
}



@end
