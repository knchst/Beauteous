//
//  NoteManager.h
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

#import <Realm/Realm.h>

@interface NoteManager : NSObject

@property RLMResults *notes;

+ (NoteManager*)sharedManager;
- (void)fetchAllNotes;
- (void)fetchAllDeletedNotes;
- (void)saveNoteWithDictionary:(NSMutableDictionary*)dictionary;
- (void)deleteObject:(Note*)note;
- (void)deleteForever:(Note*)note;
- (void)updateNoteWithDictionary:(NSMutableDictionary*)dictionary andNote:(Note*)note;
- (RLMResults*)getNoteWithPrimaryKey:(NSString *)key;
- (void)starringNote:(Note *)note;
- (void)fetchAllStarredNotes;
- (NSString*)detectPhotoURLWithString:(NSString*)string;
- (void)getLatestNotes;
- (NSUInteger)allNoteCount;
- (NSUInteger)starredNoteCount;
- (NSUInteger)deletedNoteCount;

@end
