//
//  NoteModelTest.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/15/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Kiwi.h"
#import "NoteManager.h"

@interface NoteModelTest : XCTestCase

+ (NoteManager*)sharedManager;
- (void)fetchAllNotes;
- (void)saveNoteWithDictionary:(NSMutableDictionary*)dictionary;
- (void)deleteObject:(Note*)note;
- (void)updateNoteWithDictionary:(NSMutableDictionary*)dictionary andNote:(Note*)note;
- (RLMResults*)getNoteWithPrimaryKey:(NSString *)key;
- (void)starringNote:(Note *)note;
- (void)fetchAllStarredNotes;
- (NSString*)detectPhotoURLWithString:(NSString*)string;
- (void)getLatestNotes;

@end

SPEC_BEGIN(NoteModelTestSpec)

describe(@"NoteManagerのテスト", ^{
    context(@"インスタンスの生成", ^{
        it(@"常に同じインスタンスが返ってくる", ^{
            NoteManager *manager = [NoteManager sharedManager];
            BOOL isEqual = [manager isEqual:[NoteManager sharedManager]];
            [[theValue(isEqual) should] equal:theValue(YES)];
        });
    });
});

SPEC_END



