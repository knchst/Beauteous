//
//  HomeTableViewCell.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/6/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleBottomMargin;

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 8, 0, 0);
    self.layoutMargins = UIEdgeInsetsMake(0, 8, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        self.backgroundColor = [UIColor blackColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

@end
