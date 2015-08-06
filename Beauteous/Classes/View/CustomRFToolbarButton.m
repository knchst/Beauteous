//
//  CustomRFToolbarButton.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/6/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "CustomRFToolbarButton.h"
#import "BOConst.h"
#import "BOUtility.h"

@implementation CustomRFToolbarButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 2;
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [BOUtility fontTypeBookWithSize:15];
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.layer.borderWidth = 0.5f;
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return self;
}

@end
