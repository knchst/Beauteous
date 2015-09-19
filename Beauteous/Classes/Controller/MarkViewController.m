//
//  MarkViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/7/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "MarkViewController.h"
#import "BOUtility.h"
#import "ComposeViewController.h"
#import "YALTabBarInteracting.h"

@interface MarkViewController () <YALTabBarInteracting>

@end

@implementation MarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect = [UIScreen mainScreen].bounds;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, rect.size.width, rect.size.height - 64)];
    [webView loadHTMLString:[BOUtility renderHTMLWithString:_string] baseURL:nil];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#define debug 1

#pragma mark - YALTabBarInteracting

- (void)tabBarViewWillCollapse {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewWillExpand {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewDidCollapse {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewDidExpand {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)extraLeftItemDidPress {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)extraRightItemDidPress {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    ComposeViewController *vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Compose"];
    self.navigationItem.backBarButtonItem = [BOUtility blankBarButton];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
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
