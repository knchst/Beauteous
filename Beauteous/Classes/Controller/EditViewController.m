//
//  EditViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/5/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "EditViewController.h"
#import "PreviewViewController.h"
#import "BOConst.h"
#import "BOUtility.h"
#import "NoteManager.h"

#import "SVProgressHUD.h"
#import "Parse.h"
#import "RFKeyboardToolbar.h"
#import "UIImage+ResizeMagick.h"

@interface EditViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation EditViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Edit";
    
    NSLog(@"Edit: %@", self.note);
    
    _textView.text = _note.planeString;
    
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
    note[@"updated_at"] = [NSDate date];
    NSString *note_id = [NSString stringWithFormat:@"%ld", (long)_note.id];
    note[@"id"] = note_id;
    
    [[NoteManager sharedManager] updateNoteWithDictionary:note andNote:_note];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)preview:(id)sender
{
    PreviewViewController *previewVC = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Preview"];
    previewVC.htmlString = [BOUtility renderHTMLWithString:_textView.text];
    self.navigationItem.backBarButtonItem = [BOUtility blankBarButton];
    [self.navigationController pushViewController:previewVC animated:YES];
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
//        [_textView insertText:@"![]()"];
//        UITextRange *range = _textView.selectedTextRange;
//        UITextPosition *position = [_textView positionFromPosition:range.start
//                                                            offset:-3];
//        _textView.selectedTextRange = [_textView textRangeFromPosition:position
//                                                            toPosition:position];
        [self showActionSheet];
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

- (void)showActionSheet
{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"Is image where from?"
                                                                 message:@""
                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * urlAction = [UIAlertAction actionWithTitle:@"URL"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           NSLog(@"Cancel button tapped.");
                                                       }];
    
    UIAlertAction * pickerAction = [UIAlertAction actionWithTitle:@"Your phone"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"Destructive button tapped.");
                                                              [self showImagePicker];
                                                          }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {
                                                              NSLog(@"Destructive button tapped.");
                                                          }];
    
    
    [ac addAction:urlAction];
    [ac addAction:pickerAction];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showImagePicker
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController  animated:YES completion: nil];
    } else {
        NSLog(@"Photo not available");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [SVProgressHUD show];
    
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage* resizedImage = [originalImage resizedImageByMagick:@"500x500#"];
    NSData *imageData = UIImagePNGRepresentation(resizedImage);
    PFFile *image = [PFFile fileWithName:@"image.png" data:imageData];
    
    PFObject *file = [PFObject objectWithClassName:@"Photos"];
    file[@"image"] = image;
    
    __weak EditViewController *weakSelf = self;
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            NSLog(@"%@", image.url);
            
            __strong EditViewController *strongSelf = weakSelf;
            
            [strongSelf addImageURL:image.url];
        } else {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"Error.."];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addImageURL:(NSString*)url
{
    NSMutableString *string = [NSMutableString stringWithString:_textView.text];
    [string insertString:[NSString stringWithFormat:@"![](%@)", url] atIndex:_textView.selectedRange.location];
    _textView.text = string;
    [SVProgressHUD dismiss];
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
