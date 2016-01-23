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
    self.containerView.layer.cornerRadius = 10;
    self.containerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.containerView.layer.borderWidth = 1;
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.masksToBounds = YES;
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
    self.avatarImageView.clipsToBounds = YES;
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
    __weak typeof(self) weakSelf = self;
    
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"username" equalTo:data[@"from"]];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
//        PFFile *file = object[@"avatar"];
//        NSURL *url = [NSURL URLWithString:file.url];
//        [weakSelf.avatarImageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//            weakSelf.avatarImageView.image = image;
//        }];
//    }];
}

@end
