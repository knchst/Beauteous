//
//  SignupViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/28/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "SignupViewController.h"
#import "BOConst.h"
#import "BOUtility.h"

#import "Parse.h"
#import "SVProgressHUD.h"

@interface SignupViewController () <UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation SignupViewController {
    UITextField* _activeField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSFontAttributeName: [BOUtility fontTypeHeavyWithSize:15]}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSFontAttributeName: [BOUtility fontTypeHeavyWithSize:15]}];
    self.passwordConfirmTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSFontAttributeName: [BOUtility fontTypeHeavyWithSize:15]}];
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordConfirmTextField.delegate = self;
    
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
        CGPoint scrollPoint = CGPointMake(0.0, _activeField.frame.origin.y - 180);
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

- (IBAction)signUp:(id)sender
{
    if (_emailTextField.text.length > 0 &&
        _passwordTextField.text.length > 0 &&
        [_passwordTextField.text isEqualToString:_passwordConfirmTextField.text]) {
        
        PFUser* user = [PFUser user];
        user.username = _emailTextField.text;
        user.email = _emailTextField.text;
        user.password = _passwordTextField.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
            if (error) {
                NSLog(@"%@", [error userInfo][@"error"]);
                [SVProgressHUD showErrorWithStatus:@"Error.."];
            } else {
                NSLog(@"Sign up success!");
                [SVProgressHUD showSuccessWithStatus:@"Hello."];
                [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please check the input." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
