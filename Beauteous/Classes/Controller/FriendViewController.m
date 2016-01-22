//
//  FriendViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 1/22/16.
//  Copyright © 2016 Kenichi Saito. All rights reserved.
//

#import "FriendViewController.h"
#import "FriendTableViewCell.h"
#import "BOParseManager.h"

#import "Parse.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SVProgressHUD.h"

@interface FriendViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Friends";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.navigationItem.leftBarButtonItem = close;
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = add;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BOParseManager sharedManager].friends.count;
}

- (FriendTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    PFObject *user = [BOParseManager sharedManager].friends[indexPath.row];
    NSLog(@"%@", user);
    cell.usernameLabel.text = user[@"username"];
    PFFile *file = user[@"avatar"];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:file.url] options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
        if (image == nil) {
            cell.avatarImageView.image = [UIImage imageNamed:@"Icon-76@2x"];
        } else {
            cell.avatarImageView.image = image;
        }
    }];
    
    return cell;
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)add
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Find your friend" message:@"Enter your friend username." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"Username";
        textField.delegate = weakSelf;
        textField.returnKeyType = UIReturnKeyGo;
        [textField becomeFirstResponder];
    }];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addFriendWithUsername:textField.text];
    return YES;
}

- (void)addFriendWithUsername:(NSString*)username
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
    [[BOParseManager sharedManager] addFriendWithUsername:username andBlock:^(NSError *error){
        if (error) {
            NSString *errorString = [error userInfo][@"error"];
            [SVProgressHUD showErrorWithStatus:errorString];
        } else {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@, is added!!", username]];
            [weakSelf refresh];
        }
    }];
}

- (void)refresh
{
    __weak typeof(self) weakSelf = self;
    [[BOParseManager sharedManager] fetchFriendsWithBlock:^(NSError *error){
        [weakSelf.tableView reloadData];
    }];
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
