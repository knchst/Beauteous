//
//  ComposeViewController.h
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

@interface ComposeViewController : UIViewController
@property (assign, nonatomic) BOOL isChat;
@property (strong, nonatomic) PFObject *user;
@end
