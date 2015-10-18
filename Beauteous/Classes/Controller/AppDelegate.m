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

- (void)setUpParse
{
    [Parse setApplicationId:PARSE_ID
                  clientKey:PARSE_CLIENT_KEY];
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
    RLMMigrationBlock migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        
        
        if (oldSchemaVersion < 7) {
            [migration enumerateObjects:Note.className
                                 block:^(RLMObject *oldObject, RLMObject *newObject) {
                                                     newObject[@"deleted"] = @NO;
            }];
        }
        
        
        NSLog(@"Migration complete.");
    };
    [RLMRealm setDefaultRealmSchemaVersion:7 withMigrationBlock:migrationBlock];

    //[[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self setUpParse];
    [self setUpAppearance];
    [self realmMigration];
    
    return YES;
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
