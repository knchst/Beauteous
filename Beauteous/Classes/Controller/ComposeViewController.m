//
//  ComposeViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "ComposeViewController.h"
#import "PreviewViewController.h"
#import "BOUtility.h"

#import "GHMarkdownParser.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = keyboardFrame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = 0;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)preview:(id)sender
{
    
    PreviewViewController* previewVC = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Preview"];
    previewVC.htmlString = [self renderHTML];
    
    [self.navigationController pushViewController:previewVC animated:YES];
    
    
}

- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*)renderHTML
{
    GHMarkdownParser* parser = [[GHMarkdownParser alloc] init];
    parser.options = kGHMarkdownAutoLink;
    parser.githubFlavored = YES;
    
    NSString *rendered = [parser HTMLStringFromMarkdownString:_textView.text];
    NSString *body = [NSString stringWithFormat:@"<article class=\"markdown-body\">%@</article>", rendered];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"github-markdown" ofType:@"css"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSString *style = [NSString stringWithFormat:@"<link rel=\"stylesheet\" href=\"%@\">", url];
    
    NSLog(@"HTML STRING: %@ %@", style, body);

    return [NSString stringWithFormat:@"%@%@", style, body];
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
