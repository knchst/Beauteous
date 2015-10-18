//
//  AppDelegate.h
//  Beauteous
//
//  Created by Kenichi Saito on 7/28/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMainViewController (MainViewController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController]
#define kNavigationController (UINavigationController *)[(MainViewController *)[[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController] rootViewController]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

