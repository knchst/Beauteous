//
//  UserViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 1/18/16.
//  Copyright © 2016 Kenichi Saito. All rights reserved.
//

#import "UserViewController.h"
#import "BOUtility.h"
#import "Parse.h"

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) UIButton *signUpButton;
@property BOOL isSignUp;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.signInButton.layer.cornerRadius = 22.0f;
    self.titleLabel.text = @"Welcome back!!";
    
    _isSignUp = NO;
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 32, 44, 44)];
    [closeButton setTitle:@"×" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:50]];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeButton];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    _signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(rect.size.width - 108, 44, 100, 30)];
    _signUpButton.backgroundColor = [UIColor blackColor];
    _signUpButton.layer.cornerRadius = 15.0f;
    [_signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [_signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signUpButton.titleLabel setFont:[BOUtility fontTypeBookWithSize:17]];
    [_signUpButton addTarget:self action:@selector(changeSignUp) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeButton];
    [self.contentView addSubview:_signUpButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action:(id)sender
{
    BOOL isValid = [self validate:self.usernameTextField.text and:self.passwordTextField.text];
    if (isValid) {
        if (_isSignUp) {
            [self signUpWith:self.usernameTextField.text and:self.passwordTextField.text];
        } else {
            [self signInWith:self.usernameTextField.text and:self.passwordTextField.text];
        }
    }
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeSignUp
{
    if (_isSignUp) {
        _isSignUp = NO;
        self.titleLabel.text = @"Welcome back.";
        [_signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
        [self.signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    } else {
        _isSignUp = YES;
        [_signUpButton setTitle:@"Sign In" forState:UIControlStateNormal];
        self.titleLabel.text = @"Welcome to Beauteous Chat.";
        [self.signInButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    }
}

- (void)signUpWith:(NSString*)username and:(NSString*)password
{
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Sign Up Success!!");
            [self close];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            [self showErrorWith:errorString];
        }
    }];
}

- (void)signInWith:(NSString*)username and:(NSString*)password
{
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"Sign In Success!!");
                                            [self close];
                                        } else {
                                            NSString *errorString = [error userInfo][@"error"];
                                            NSLog(@"%@", errorString);
                                            [self showErrorWith:errorString];
                                        }
                                    }];
}

- (void)showErrorWith:(NSString*)errorString
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)validate:(NSString*)username and:(NSString*)password
{
    if (username.length < 1 || password.length < 1) {
        [self showErrorWith:@"Username and Password are must be over 6 characters"];
        
        return NO;
    }
    
    return YES;
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
