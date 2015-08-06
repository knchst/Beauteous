//
//  PreviewViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "PreviewViewController.h"
#import "BOUtility.h"

@interface PreviewViewController ()

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Preview";
    
    [_webView loadHTMLString:[BOUtility renderHTMLWithString:_htmlString] baseURL:[NSURL URLWithString:@""]];
    
    if (self.PDF) {
        UIBarButtonItem *make = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(make)];
        self.navigationItem.rightBarButtonItem = make;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)renderPDF
{
    UIImage *tableImage = [BOUtility screenShotScrollView:_webView.scrollView];
    NSData *pdfData = [BOUtility convertImageToPDF:tableImage];
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *path = [tmpDirectory stringByAppendingPathComponent:@"image.pdf"];
    [pdfData writeToFile:path atomically:NO];
    
    [self openPath:path];
}

- (void)openPath:(NSString *)pathString {
    
    NSURL *path = [NSURL fileURLWithPath:pathString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:path];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    webView.scalesPageToFit = YES;
    [webView loadRequest:urlRequest];
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = webView;
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    
    vc.navigationItem.rightBarButtonItem = share;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    //system([[NSString stringWithFormat:@"open '%@'", self.pdfPath] cStringUsingEncoding:NSUTF8StringEncoding]);
    
}

- (void)make
{
    [self renderPDF];
}

- (void)share
{
    NSString *title = @"From Beauteous.";
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *path = [tmpDirectory stringByAppendingPathComponent:@"image.pdf"];
    NSData *pdfData = [NSData dataWithContentsOfFile:path];
    
    UIActivityViewController *ac = [[UIActivityViewController alloc] initWithActivityItems:@[title, pdfData] applicationActivities:nil];
    
    [self.navigationController presentViewController:ac animated:YES completion:nil];
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
