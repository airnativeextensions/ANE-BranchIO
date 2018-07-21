//
//  TypeConversion.m
//  GooglePlusIosExtension
//
//  Created by Aymeric Lamboley on 26/01/2015.
//  Copyright (c) 2015 DaVikingCode. All rights reserved.
//

#import "TypeConversion.h"

@implementation TypeConversion



+ (NSString *) ConvertNSDictionaryToJSONString:(NSDictionary *) dictionary {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    
    NSString *JSONString;
    
    if (!jsonData)
    {
        JSONString = [[NSString alloc] init];
    }
    else
    {
        JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        JSONString = [JSONString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    }
    
    return JSONString;
}

@end
