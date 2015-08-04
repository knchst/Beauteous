//
//  AllTableViewCell.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/4/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "AllTableViewCell.h"

@implementation AllTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDate:(Note *)note
{
    self.titleLabel.text = note.title;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd";
    NSAttributedString *dateAttrString = [[NSAttributedString alloc] initWithString:[df stringFromDate:note.updated_at] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir-LightOblique" size:12]}];
    NSAttributedString *bodyAttrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", note.planeString]];
    
    NSMutableAttributedString *bodyString = [[NSMutableAttributedString alloc] init];
    [bodyString appendAttributedString:dateAttrString];
    [bodyString appendAttributedString:bodyAttrString];
    self.bodyLabel.attributedText = bodyString;
    
}

@end
