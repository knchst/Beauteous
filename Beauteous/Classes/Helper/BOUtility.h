//
//  BOUtility.h
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BOUtility : NSObject
+ (UIFont*)fontTypeBookWithSize:(CGFloat)size;
+ (UIFont*)fontTypeHeavyWithSize:(CGFloat)size;
+ (UIStoryboard*)storyboard;
+ (UIBarButtonItem*)blankBarButton;
+ (NSString*)renderHTMLWithString:(NSString*)string;
+ (UIColor*)pinkColor;
+ (UIColor*)yellowColor;
+ (NSArray*)pickUpURLFromString:(NSString*)string;

typedef void (^callback)(NSDictionary* , NSError*);
+ (void)getQuoteTodayWithBlock:(callback)callback;
@end
