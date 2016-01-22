//
//  FriendTableViewCell.h
//  Beauteous
//
//  Created by Kenichi Saito on 1/22/16.
//  Copyright © 2016 Kenichi Saito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end
