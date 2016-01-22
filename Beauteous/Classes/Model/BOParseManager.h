//
//  BOParseManager.h
//  Beauteous
//
//  Created by Kenichi Saito on 8/20/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOParseManager : NSObject

@property (copy, nonatomic) NSArray *friends;
+ (BOParseManager*)sharedManager;
- (void)addFriendWithUsername:(NSString *)username andBlock:(void (^)(NSError *error))block;
- (void)fetchFriendsWithBlock:(void (^)(NSError *error))block;
@end
