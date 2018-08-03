//
//  BIOTypeConversion.h
//  GooglePlusIosExtension
//
//  Created by Aymeric Lamboley on 26/01/2015.
//  Copyright (c) 2015 DaVikingCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

@interface BIOTypeConversion : NSObject


+ (NSString *) ConvertNSDictionaryToJSONString:(NSDictionary *) dictionary;

@end
