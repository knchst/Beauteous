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
+ (UIFont*)fontTypeMediumWithSize:(CGFloat)size;
+ (UIStoryboard*)storyboard;
+ (UIBarButtonItem*)blankBarButton;
+ (NSString*)renderHTMLWithString:(NSString*)string;
+ (UIColor*)pinkColor;
+ (UIColor*)yellowColor;
+ (NSArray*)pickUpURLFromString:(NSString*)string;
+ (UIImage*)screenShotScrollView:(UIScrollView*)scrollView;
+ (NSData*)convertImageToPDF:(UIImage*)image;
+ (CGRect)screenSize;
+ (BOOL)checkDevice;
+ (NSData*)resizeImageWithImage:(UIImage*)image;

typedef void (^Callback)(NSMutableArray*, NSError*);
+ (void)interestingImageFromFlickrWithCallback:(Callback)callback;
@end
