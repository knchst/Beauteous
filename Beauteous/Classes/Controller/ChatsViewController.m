//
//  ChatsViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 1/18/16.
//  Copyright © 2016 Kenichi Saito. All rights reserved.
//

#import "ChatsViewController.h"
#import "UserViewController.h"
#import "BOUtility.h"

#import "Parse.h"

@interface ChatsViewController ()

@end

@implementation ChatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[PFUser logOut];
    [self checkUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkUser
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
    } else {
        UserViewController *vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"User"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
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
