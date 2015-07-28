//
//  SigninViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/28/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "SigninViewController.h"
#import "BOConst.h"

#import "Parse.h"
#import "SVProgressHUD.h"

@interface SigninViewController () <UIScrollViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SigninViewController {
    UITextField* _activeField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSFontAttributeName: [UIFont fontWithName:BO_FONT_HEAVY size:15]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSFontAttributeName: [UIFont fontWithName:BO_FONT_HEAVY size:15]}];
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.scrollView.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(handleKeyboardWillShowNotification:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(handleKeyboardWillHideNotification:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
}

- (void)handleKeyboardWillShowNotification:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (_activeField != nil) {
        CGPoint scrollPoint = CGPointMake(0.0, _activeField.frame.origin.y - 150);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)handleKeyboardWillHideNotification:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signIn:(id)sender
{
    if (_emailTextField.text.length > 0 && _passwordTextField.text.length > 0) {
        
        [PFUser logInWithUsernameInBackground:_emailTextField.text
                                     password:_passwordTextField.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                NSLog(@"Sign in success!");
                                                [SVProgressHUD showSuccessWithStatus:@""];
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            } else {
                                                NSLog(@"%@", [error userInfo][@"error"]);
                                                [SVProgressHUD showErrorWithStatus:@"Error"];
                                            }
                                        }];
    }
}

- (IBAction)signUp:(id)sender
{
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
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
