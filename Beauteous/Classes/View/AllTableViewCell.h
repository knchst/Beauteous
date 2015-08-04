//
//  AllTableViewCell.h
//  Beauteous
//
//  Created by Kenichi Saito on 8/4/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "MCSwipeTableViewCell.h"
#import "Note.h"

@interface AllTableViewCell : MCSwipeTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

- (void)setDate:(Note*)note;
@end
