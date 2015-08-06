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

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NSLog(@"Detail: htmlString = %@", _note.htmlString);
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(edit)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
