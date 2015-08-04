//
//  NoteManager.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "NoteManager.h"

#import "Note.h"

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
    return [Note allObjects];
}

- (void)saveNoteWithDictionary:(NSMutableDictionary*)dictionary
{
    Note *note = [[Note alloc] init];
    note.title = dictionary[@"title"];
    note.planeString = dictionary[@"planeString"];
    note.htmlString = dictionary[@"htmlString"];
    
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [[RLMRealm defaultRealm] addObject:note];
    [[RLMRealm defaultRealm] commitWriteTransaction];
    
}

@end
