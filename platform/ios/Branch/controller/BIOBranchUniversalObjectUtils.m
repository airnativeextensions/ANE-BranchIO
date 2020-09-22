//
//  BIOBranchUniversalObjectUtils.m
//  Branch
//
//  Created by Michael Archbold on 22/9/20.
//  Copyright © 2020 distriqt. All rights reserved.
//

#import "BIOBranchUniversalObjectUtils.h"

@implementation BIOBranchUniversalObjectUtils





+(BranchLinkProperties*) linkPropertiesFromDict: (NSDictionary*)properties
{
    BranchLinkProperties* lp = [[BranchLinkProperties alloc ] init];
    for (NSString* key in properties)
    {
        if ([key isEqualToString: @"channel"])
        {
            lp.channel = [properties objectForKey: key];
        }
        else if ([key isEqualToString: @"feature"])
        {
            lp.feature = [properties objectForKey: key];
        }
        else if ([key isEqualToString: @"campaign"])
        {
            lp.campaign = [properties objectForKey: key];
        }
        else if ([key isEqualToString: @"alias"])
        {
            lp.alias = [properties objectForKey: key];
        }
        else if ([key isEqualToString: @"duration"])
        {
            lp.matchDuration = [(NSNumber*)[properties objectForKey: key] unsignedIntegerValue];
        }
        else if ([key isEqualToString: @"stage"])
        {
            lp.stage = [properties objectForKey: key];
        }
        
        else if ([key isEqualToString: @"controlParameters"])
        {
            NSDictionary* cpDict = [properties objectForKey: key];
            for (NSString* cpKey in cpDict)
            {
                [lp addControlParam: cpKey
                          withValue: [cpDict objectForKey: cpKey]];
            }
        }
        
        
        else if ([key isEqualToString: @"tags"])
        {
            lp.tags = [properties objectForKey: key];
        }
        
    }
    return lp;
}


+(BranchUniversalObject*) buoFromDict: (NSDictionary*)properties
{
    BranchUniversalObject* buo = [[BranchUniversalObject alloc] init];
    
    for (NSString* key in properties)
    {
        if ([key isEqualToString: @"canonicalIdentifier"])
        {
            buo.canonicalIdentifier = [properties objectForKey: key];
        }
        else if ([key isEqualToString: @"canonicalUrl"])
        {
            buo.canonicalUrl = [properties objectForKey: key];
        }
        else if ([key isEqualToString: @"title"])
        {
            buo.title = [properties objectForKey: key];
        }
        else if ([key isEqualToString: @"contentDescription"])
        {
            buo.contentDescription = [properties objectForKey: key];
        }
        else if ([key isEqualToString: @"contentImageUrl"])
        {
            buo.imageUrl = [properties objectForKey: key];
        }
        else if ([key isEqualToString: @"contentIndexingMode"])
        {
            NSString* mode = [properties objectForKey: key];
            buo.publiclyIndex = [mode isEqualToString: @"public"];
        }
        else if ([key isEqualToString: @"localIndexMode"])
        {
            NSString* mode = [properties objectForKey: key];
            buo.locallyIndex = [mode isEqualToString: @"public"];
        }
        
        else if ([key isEqualToString: @"metadata"])
        {
            NSDictionary* metadataDict = [properties objectForKey: key];
            for (NSString* metadataKey in metadataDict)
            {
                [buo.contentMetadata.customMetadata setObject: [metadataDict objectForKey: metadataKey]
                                                       forKey: metadataKey];
            }
        }
    }
    
    return buo;
}


@end
