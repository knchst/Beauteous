//
//  PhotoAllTableViewCell.h
//  Beauteous
//
//  Created by Kenichi Saito on 8/6/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAllTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
