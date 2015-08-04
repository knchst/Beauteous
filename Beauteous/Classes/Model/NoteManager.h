//
//  NoteManager.h
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm.h"

@interface NoteManager : NSObject

@property RLMResults *notes;

+ (NoteManager*)sharedManager;
- (void)fetchAllNotes;
- (void)saveNoteWithDictionary:(NSMutableDictionary*)dictionary;
@end
