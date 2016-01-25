//
//  Message.h
//  Beauteous
//
//  Created by Kenichi Saito on 1/25/16.
//  Copyright © 2016 Kenichi Saito. All rights reserved.
//

#import <Realm/Realm.h>

@interface Message : RLMObject

@property NSInteger id;
@property NSString *title;
@property NSString *planeString;
@property NSString *htmlString;
@property NSString *avatar;
@property NSDate   *created_at;
@property NSDate   *updated_at;
@property BOOL     starred;
@property BOOL     deleted;
@property NSString *photoUrl;
@property NSString *to;
@property NSString *from;
@property NSString *objectId;

@end
