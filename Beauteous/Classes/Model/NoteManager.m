//
//  NoteManager.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "NoteManager.h"
#import "BOUtility.h"

static NoteManager *sharedManager = nil;

@implementation NoteManager

+ (NoteManager*)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [NoteManager new];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)fetchAllNotes
{
    //self.notes = [[Note allObjects] sortedResultsUsingProperty:@"updated_at" ascending:NO];
    
    RLMResults *notes = [Note objectsWhere:@"deleted = NO"];
    self.notes = [notes sortedResultsUsingProperty:@"updated_at" ascending:NO];
}

- (void)fetchAllStarredNotes
{
    RLMResults *notes = [Note objectsWhere:@"starred = YES"];
    self.notes = [notes sortedResultsUsingProperty:@"updated_at" ascending:NO];
}

- (void)fetchAllDeletedNotes
{
    RLMResults *notes = [Note objectsWhere:@"deleted = YES"];
    self.notes = [notes sortedResultsUsingProperty:@"updated_at" ascending:NO];
}

- (RLMResults*)getNoteWithPrimaryKey:(NSString*)key
{
    NSString *where = [NSString stringWithFormat:@"id = %@", key];
    RLMResults *note = [Note objectsInRealm:[RLMRealm defaultRealm] where:where];
    
    return note;
}

- (void)saveNoteWithDictionary:(NSMutableDictionary*)dictionary
{
    Note *new_note = [[Note alloc] init];
    new_note.title = dictionary[@"title"];
    new_note.planeString = dictionary[@"planeString"];
    new_note.htmlString = dictionary[@"htmlString"];
    new_note.created_at = dictionary[@"created_at"];
    new_note.updated_at = dictionary[@"updated_at"];
    new_note.photoUrl = dictionary[@"photoUrl"];
    
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    new_note.id = time;
    
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [Note createOrUpdateInRealm:[RLMRealm defaultRealm] withValue:new_note];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

- (void)updateNoteWithDictionary:(NSMutableDictionary*)dictionary andNote:(Note *)note
{
    Note *new_note = [[Note alloc] init];
    new_note.title = dictionary[@"title"];
    new_note.planeString = dictionary[@"planeString"];
    new_note.htmlString = dictionary[@"htmlString"];
    new_note.updated_at = dictionary[@"updated_at"];
    new_note.id = [dictionary[@"id"] integerValue];
    new_note.starred = note.starred;
    new_note.deleted = note.deleted;
    new_note.photoUrl = [self detectPhotoURLWithString:dictionary[@"photoUrl"]];
    
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [Note createOrUpdateInRealm:[RLMRealm defaultRealm] withValue:new_note];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

- (void)starringNote:(Note *)note
{
    Note *new_note = [[Note alloc] init];
    new_note.title = note.title;
    new_note.planeString = note.planeString;
    new_note.htmlString = note.htmlString;
    new_note.updated_at = note.updated_at;
    new_note.id = note.id;
    new_note.deleted = note.deleted;
    new_note.photoUrl = [self detectPhotoURLWithString:note.planeString];
    
    if (note.starred) {
        new_note.starred = NO;
    } else {
        new_note.starred = YES;
    }
    
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [Note createOrUpdateInRealm:[RLMRealm defaultRealm] withValue:new_note];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

- (void)deleteObject:(Note*)note
{
    Note *new_note = [[Note alloc] init];
    new_note.title = note.title;
    new_note.planeString = note.planeString;
    new_note.htmlString = note.htmlString;
    new_note.updated_at = note.updated_at;
    new_note.id = note.id;
    new_note.starred = note.starred;
    new_note.photoUrl = [self detectPhotoURLWithString:note.planeString];
    
    if (note.deleted) {
        new_note.deleted = NO;
    } else {
        new_note.deleted = YES;
    }
    
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [Note createOrUpdateInRealm:[RLMRealm defaultRealm] withValue:new_note];
    [[RLMRealm defaultRealm] commitWriteTransaction];

}

- (void)deleteForever:(Note*)note
{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] deleteObject:note];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

- (NSString*)detectPhotoURLWithString:(NSString*)string
{
    NSArray *URLs = [BOUtility pickUpURLFromString:string];
    
    // NSLog(@"%@", URLs);
    
    if (URLs.count > 0) {
        return URLs[0];
    }
    
    return @"";
}

- (void)getLatestNotes
{
    self.notes = [[Note allObjects] sortedResultsUsingProperty:@"updated_at" ascending:NO];
}

@end
