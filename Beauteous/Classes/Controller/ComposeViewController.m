//
//  ComposeViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "ComposeViewController.h"
#import "PreviewViewController.h"
#import "NoteManager.h"
#import "BOUtility.h"
#import "BOConst.h"
#import "Note.h"

#import "Realm.h"
#import "RFKeyboardToolbar.h"
#import "SVProgressHUD.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpToolBar];
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
    PreviewViewController *previewVC = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Preview"];
    previewVC.htmlString = [BOUtility renderHTMLWithString:_textView.text];
    self.navigationItem.backBarButtonItem = [BOUtility blankBarButton];
    [self.navigationController pushViewController:previewVC animated:YES];
    
}

- (IBAction)done:(id)sender
{
    NSMutableDictionary *note = [NSMutableDictionary dictionary];
    
    if (_textView.text.length <= 0) {
        note[@"title"] = @"No title";
    } else {
        note[@"title"] = [_textView.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]][0];
    }
    
    note[@"planeString"] = _textView.text;
    note[@"htmlString"] = [BOUtility renderHTMLWithString:_textView.text];
    note[@"created_at"] = [NSDate date];
    note[@"updated_at"] = [NSDate date];
    
    [[NoteManager sharedManager] saveNoteWithDictionary:note];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpToolBar
{
    RFToolbarButton *header = [RFToolbarButton buttonWithTitle:@"Header"];
    RFToolbarButton *quote  = [RFToolbarButton buttonWithTitle:@"Quote"];
    RFToolbarButton *table  = [RFToolbarButton buttonWithTitle:@"Table"];
    RFToolbarButton *image  = [RFToolbarButton buttonWithTitle:@"Image"];
    RFToolbarButton *link   = [RFToolbarButton buttonWithTitle:@"Link"];
    RFToolbarButton *list   = [RFToolbarButton buttonWithTitle:@"List"];
    RFToolbarButton *italic = [RFToolbarButton buttonWithTitle:@"Italic"];
    RFToolbarButton *bold   = [RFToolbarButton buttonWithTitle:@"Bold"];
    RFToolbarButton *code   = [RFToolbarButton buttonWithTitle:@"Code"];
    
    // Add a button target to the exampleButton
    [header addEventHandler:^{
        [_textView insertText:@"# "];
    } forControlEvents:UIControlEventTouchUpInside];
    [quote addEventHandler:^{
        [_textView insertText:@"> "];
    } forControlEvents:UIControlEventTouchUpInside];
    [table addEventHandler:^{
        [_textView insertText:@"| ------ |"];
    } forControlEvents:UIControlEventTouchUpInside];
    [image addEventHandler:^{
        [_textView insertText:@"![]()"];
        UITextRange *range = _textView.selectedTextRange;
        UITextPosition *position = [_textView positionFromPosition:range.start
                                                            offset:-3];
        _textView.selectedTextRange = [_textView textRangeFromPosition:position
                                                            toPosition:position];
    } forControlEvents:UIControlEventTouchUpInside];
    [link addEventHandler:^{
        [_textView insertText:@"[]()"];
        UITextRange *range = _textView.selectedTextRange;
        UITextPosition *position = [_textView positionFromPosition:range.start
                                                            offset:-3];
        _textView.selectedTextRange = [_textView textRangeFromPosition:position
                                                            toPosition:position];
    } forControlEvents:UIControlEventTouchUpInside];
    [list addEventHandler:^{
        [_textView insertText:@"- "];
    } forControlEvents:UIControlEventTouchUpInside];
    [italic addEventHandler:^{
        // Do anything in this block here
        [_textView insertText:@"__"];
        UITextRange *range = _textView.selectedTextRange;
        UITextPosition *position = [_textView positionFromPosition:range.start
                                                            offset:-1];
        _textView.selectedTextRange = [_textView textRangeFromPosition:position
                                                            toPosition:position];
    } forControlEvents:UIControlEventTouchUpInside];
    [bold addEventHandler:^{
        // Do anything in this block here
        [_textView insertText:@"****"];
        UITextRange *range = _textView.selectedTextRange;
        UITextPosition *position = [_textView positionFromPosition:range.start
                                                            offset:-3];
        _textView.selectedTextRange = [_textView textRangeFromPosition:position
                                                            toPosition:position];
    } forControlEvents:UIControlEventTouchUpInside];
    [code addEventHandler:^{
        // Do anything in this block here
        [_textView insertText:@"``"];
        UITextRange *range = _textView.selectedTextRange;
        UITextPosition *position = [_textView positionFromPosition:range.start
                                                            offset:-1];
        _textView.selectedTextRange = [_textView textRangeFromPosition:position
                                                            toPosition:position];
    } forControlEvents:UIControlEventTouchUpInside];
    
    // Create an RFKeyboardToolbar, adding all of your buttons, and set it as your inputAcessoryView
    _textView.inputAccessoryView = [RFKeyboardToolbar toolbarWithButtons:@[
                                                                           header,
                                                                           quote,
                                                                           image,
                                                                           table,
                                                                           link,
                                                                           list,
                                                                           italic,
                                                                           bold,
                                                                           code
                                                                           ]];
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
