//
//  Message.m
//  Beauteous
//
//  Created by Kenichi Saito on 1/25/16.
//  Copyright © 2016 Kenichi Saito. All rights reserved.
//

#import "Message.h"

@implementation Message

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
             @"avatar"      : @"",
             @"to"          : @"",
             @"from"        : @"",
             @"objectId"    : @"",
             @"created_at"  : created_at,
             @"updated_at"  : updated_at,
             @"starred"     : @NO,
             @"deleted"     : @NO
             };
}

@end
