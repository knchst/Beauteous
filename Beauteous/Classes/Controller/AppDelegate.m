//
//  AppDelegate.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/28/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "AppDelegate.h"
#import "BOConst.h"
#import "BOUtility.h"
#import "Note.h"

#import <Realm/Realm.h>
#import "Parse.h"

#import "YALFoldingTabBarController.h"
#import "YALAnimatingTabBarConstants.h"
#import "YALTabBarItem.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)setUpParseWithApplication:(UIApplication*)application
{
    [Parse setApplicationId:PARSE_ID
                  clientKey:PARSE_CLIENT_KEY];
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
}

- (void)setUpAppearance
{
    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSFontAttributeName: [BOUtility fontTypeBookWithSize:19]};
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"Back"];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Back"];
    
    
    [UITextView appearance].tintColor = [UIColor blackColor];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSFontAttributeName: [BOUtility fontTypeBookWithSize:17]}];

}

- (void)realmMigration
{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 8;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < 8) {
            [migration enumerateObjects:Note.className
                                  block:^(RLMObject *oldObject, RLMObject *newObject) {
                                      newObject[@"deleted"] = @NO;
                                  }];
        }
    };
    
    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    [RLMRealm defaultRealm];
    
    //[[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error:nil];
}

- (void)clearBadge
{
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation.badge = 0;
    [installation saveInBackground];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setUpParseWithApplication:application];
    [self setUpAppearance];
    [self realmMigration];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setDeviceTokenFromData:deviceToken];
    installation.channels = @[@"chat", @"news"];
    
    if ([PFUser currentUser]) {
        [installation setObject:[PFUser currentUser] forKey:@"user"];
    }
    [installation saveEventually];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self clearBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
