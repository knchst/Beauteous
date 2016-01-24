//
//  ChatTableViewCell.h
//  Beauteous
//
//  Created by Kenichi Saito on 1/23/16.
//  Copyright © 2016 Kenichi Saito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

@interface ChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)setData:(PFObject*)data;

@end
