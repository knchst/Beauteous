//
//  ChatTableViewCell.m
//  Beauteous
//
//  Created by Kenichi Saito on 1/23/16.
//  Copyright © 2016 Kenichi Saito. All rights reserved.
//

#import "ChatTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
    self.avatarImageView.clipsToBounds = YES;
    
    self.separatorInset = UIEdgeInsetsZero;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(PFObject *)data
{
    NSLog(@"%@", data);
    self.bodyLabel.text = data[@"planeString"];
    self.usernameLabel.text = data[@"from"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd HH:mm";
    self.dateLabel.text = [formatter stringFromDate:data.createdAt];
    __weak typeof(self) weakSelf = self;
    
    NSURL *avatarUrl = [NSURL URLWithString:data[@"avatar"]];
    [weakSelf.avatarImageView sd_setImageWithURL:avatarUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
    }];
}

@end
