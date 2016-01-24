//
//  DetailViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/5/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "DetailViewController.h"
#import "EditViewController.h"
#import "BOUtility.h"
#import "BOConst.h"
#import "NoteManager.h"
#import "SettingsViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NSLog(@"Detail: htmlString = %@", _note.htmlString);
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Pen"] style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet)];

    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *note_id = [NSString stringWithFormat:@"%ld", (long)_note.id];
    RLMResults *notes = [[NoteManager sharedManager] getNoteWithPrimaryKey:note_id];
    Note *note = notes[0];
    [_webView loadHTMLString:[BOUtility renderHTMLWithString:note.planeString] baseURL:[NSURL URLWithString:@""]];
    
    self.title = note.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)edit
{
    EditViewController *editVC = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Edit"];
    editVC.note = self.note;
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:editVC];
    [self.navigationController presentViewController:navigationVC animated:YES completion:nil];
}

- (void)share
{
    // NSString *title = _note.title;
    NSString *html = _note.planeString;
    
    UIActivityViewController *ac = [[UIActivityViewController alloc] initWithActivityItems:@[html] applicationActivities:nil];
    
    if ([BOUtility checkDevice]) {
        CGRect rect = CGRectMake(self.view.frame.size.width - 50, 64, 0, 0);
        ac.popoverPresentationController.sourceView = self.webView;
        ac.popoverPresentationController.sourceRect = rect;
    }
    
    [self.navigationController presentViewController:ac animated:YES completion:nil];
}

- (void)showActionSheet
{
    UIAlertController * ac = [[UIAlertController alloc] init];
    
    if ([BOUtility checkDevice]) {
        CGRect rect = CGRectMake(self.view.frame.size.width - 50, 64, 0, 0);
        ac.popoverPresentationController.sourceView = self.webView;
        ac.popoverPresentationController.sourceRect = rect;
    }
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction * editAction = [UIAlertAction actionWithTitle:@"Edit"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [weakSelf edit];
                                                       }];
    
    
    UIAlertAction * shareAction = [UIAlertAction actionWithTitle:@"Share"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [weakSelf share];
                                                          }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    
    
    [ac addAction:editAction];
    [ac addAction:shareAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
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
