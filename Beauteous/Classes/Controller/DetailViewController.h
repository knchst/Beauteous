//
//  DetailViewController.h
//  Beauteous
//
//  Created by Kenichi Saito on 8/5/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) Note *note;
@end
