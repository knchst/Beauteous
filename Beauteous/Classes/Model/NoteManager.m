//
//  NoteManager.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "NoteManager.h"

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
    self.notes = [Note allObjects];
}

- (RLMResults*)getAllNotesForParse
{
    RLMResults *notes = [Note allObjects];
    [notes sortedResultsUsingProperty:@"updated_at" ascending:NO];
    return notes;
}

- (void)saveNoteWithDictionary:(NSMutableDictionary*)dictionary
{
    Note *note = [[Note alloc] init];
    note.title = dictionary[@"title"];
    note.planeString = dictionary[@"planeString"];
    note.htmlString = dictionary[@"htmlString"];
    note.created_at = dictionary[@"created_at"];
    note.updated_at = dictionary[@"updated_at"];
    
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] addObject:note];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

- (void)deleteObject:(Note*)note
{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] deleteObject:note];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

@end
