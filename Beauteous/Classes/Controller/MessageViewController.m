//
//  MessageViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 1/26/16.
//  Copyright © 2016 Kenichi Saito. All rights reserved.
//

#import "MessageViewController.h"
#import "BOUtility.h"

@interface MessageViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_webView loadHTMLString:[BOUtility renderHTMLWithString:self.message.planeString] baseURL:[NSURL URLWithString:@""]];
    
    self.title = self.message.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
