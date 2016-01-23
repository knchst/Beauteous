//
//  BOParseManager.h
//  Beauteous
//
//  Created by Kenichi Saito on 8/20/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOParseManager : NSObject

@property (copy, nonatomic) NSMutableArray *friends;
@property (copy, nonatomic) NSMutableArray *messages;

+ (BOParseManager*)sharedManager;
- (void)addFriendWithUsername:(NSString *)username andBlock:(void (^)(NSError *error))block;
- (void)deleteFriendWithUsername:(NSString*)username andBlock:(void (^)(NSError *error))block;
- (void)fetchFriendsWithBlock:(void (^)(NSError *error))block;
- (void)sendNoteWithUsername:(NSString*)username andNote:(NSDictionary*)note andBlock:(void (^)(NSError *error))block;
- (void)fetchMessagesWithBlock:(void (^)(NSError *error))block;
@end
