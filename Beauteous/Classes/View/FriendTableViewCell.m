//
//  FriendTableViewCell.m
//  Beauteous
//
//  Created by Kenichi Saito on 1/22/16.
//  Copyright © 2016 Kenichi Saito. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    CGRect frame = self.avatarImageView.frame;
    self.avatarImageView.layer.cornerRadius = frame.size.width / 2;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
