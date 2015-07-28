//
//  BOUtility.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "BOUtility.h"
#import "BOConst.h"

@implementation BOUtility

+ (UIFont*)fontTypeBookWithSize:(CGFloat)size
{
    return [UIFont fontWithName:BO_FONT_BOOK size:size];
}

+ (UIFont*)fontTypeHeavyWithSize:(CGFloat)size
{
    return [UIFont fontWithName:BO_FONT_HEAVY size:size];
}

+ (UIStoryboard*)storyboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

@end
