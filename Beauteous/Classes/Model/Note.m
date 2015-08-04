//
//  Note.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "Note.h"

@implementation Note

+ (NSString *)primaryKey {
    return @"id";
}

+ (NSDictionary *)defaultPropertyValues
{
    NSDate *created_at = [NSDate date];
    NSDate *updated_at = [NSDate date];
    return @{
             @"title"       : @"No title.",
             @"planeString" : @"",
             @"htmlString"  : @"",
             @"created_at"  : created_at,
             @"updated_at"  : updated_at
             };
}
@end
