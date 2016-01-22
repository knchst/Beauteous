//
//  BOParseManager.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/20/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "BOParseManager.h"
#import "Parse.h"

static BOParseManager *sharedManager = nil;

@implementation BOParseManager

+ (BOParseManager*)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [BOParseManager new];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.friends = @[];
    }
    return self;
}

- (void)addFriendWithUsername:(NSString *)username andBlock:(void (^)(NSError * _Nullable error))block
{
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relation = [currentUser relationForKey:@"friend"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error) {
            block(error);
        } else {
            [relation addObject:object];
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                block(error);
            }];
        }
    }];
}

- (void)fetchFriendsWithBlock:(void (^)(NSError *_Nullable error))block
{
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relation = [currentUser relationForKey:@"friend"];
    PFQuery *query = [relation query];
    
    __weak typeof(self) weakSelf = self;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        NSLog(@"%@", objects);
        weakSelf.friends = objects;
        block(error);
    }];
}

@end
