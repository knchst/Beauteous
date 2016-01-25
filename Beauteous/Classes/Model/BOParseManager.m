//
//  BOParseManager.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/20/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "BOParseManager.h"
#import "Message.h"

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
        NSLog(@"Init BOParseManager");
        self.friends = [NSMutableArray array];
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

- (void)deleteFriendWithUsername:(NSString*)username andBlock:(void (^)(NSError *_Nullable error))block
{
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *relation = [currentUser relationForKey:@"friend"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:username];
    [query whereKey:@"username" notEqualTo:currentUser.username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error) {
            block(error);
        } else {
            [relation removeObject:object];
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
        weakSelf.friends = [objects mutableCopy];
        block(error);
    }];
}

- (void)sendNoteWithUsername:(NSString*)username andNote:(NSDictionary*)note andBlock:(void (^)(NSError *_Nullable error))block
{
    PFObject *noteObject = [PFObject objectWithClassName:@"Message"];
    noteObject[@"title"] = note[@"title"];
    noteObject[@"planeString"] = note[@"planeString"];
    noteObject[@"htmlString"] = note[@"htmlString"];
    noteObject[@"photoUrl"] = note[@"photoUrl"];
    
    noteObject[@"from"] = [PFUser currentUser].username;
    noteObject[@"to"] = username;
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        PFFile *file = object[@"avatar"];
        noteObject[@"avatar"] = file.url;
        
        [noteObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            block(error);
        }];

    }];
}

- (void)fetchMessagesWithBlock:(void (^)(NSError *_Nullable error))block
{
    NSString *username = [PFUser currentUser].username;
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"to" equalTo:username];
    __weak typeof(self) weakSelf = self;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        NSLog(@"FETCHED %@", objects);
        //weakSelf.messages = [objects mutableCopy];
        [weakSelf saveMessagesToRealmWithObjects:objects];
        [weakSelf fetchAllMessages];
        block(error);
    }];
}

- (void)fetchAllMessages
{
    RLMResults *notes = [Message allObjects];
    self.messages = [notes sortedResultsUsingProperty:@"updated_at" ascending:NO];
    
    NSLog(@"%@", notes);
}

- (void)saveMessagesToRealmWithObjects:(NSArray*)objects
{
    RLMResults *allMessages = [Message allObjects];
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] deleteObjects:allMessages];
    [[RLMRealm defaultRealm] commitWriteTransaction];

    [[RLMRealm defaultRealm] beginWriteTransaction];
    [objects enumerateObjectsUsingBlock:^(PFObject *object, NSUInteger idx, BOOL *stop){
        NSLog(@"save %@", object);
        Message *message = [[Message alloc] init];
        message.id = idx;
        message.objectId = object.objectId;
        message.title = object[@"title"];
        message.planeString = object[@"planeString"];
        message.htmlString = object[@"htmlString"];
        message.avatar = object[@"avatar"];
        message.created_at = object.createdAt;
        message.updated_at = object.updatedAt;
        message.photoUrl = object[@"photoUrl"];
        message.to = object[@"to"];
        message.from = object[@"from"];
        [[RLMRealm defaultRealm] addObject:message];
    }];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    NSLog(@"finished");
}

- (void)removeMessageWithObjectId:(NSString*)objectId
{
    NSString *queryString = [NSString stringWithFormat:@"objectId = '%@'", objectId];
    RLMResults *message = [Message objectsWhere:queryString];
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] deleteObject:message.firstObject];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Message"];
    [query whereKey:@"objectId" equalTo:objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        [object deleteInBackground];
    }];
}

@end
