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
#import "BOParseManager.h"
#import "FriendViewController.h"
#import "ChatTableViewCell.h"
#import "ChatPhotoTableViewCell.h"

#import "Parse.h"
#import "SVProgressHUD.h"
#import "UIScrollView+EmptyDataSet.h"

@interface ChatsViewController () <UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ChatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Chat";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor clearColor];
    BOOL isLogin = [self isLogin];
    if (isLogin) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Pen"] style:UIBarButtonItemStylePlain target:self action:@selector(write)];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Pen"] style:UIBarButtonItemStylePlain target:self action:@selector(write)];
        [self refresh];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isLogin
{
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        return YES;
    } else {
        UserViewController *vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"User"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [BOParseManager sharedManager].messages.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *message = [BOParseManager sharedManager].messages[indexPath.row];
    if ([message[@"photoUrl"] isEqualToString:@""]) {
        ChatTableViewCell *chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
        if (chatCell == nil) {
            chatCell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatCell"];
        }
        [chatCell setData:message];
        return chatCell;
    } else {
        ChatPhotoTableViewCell *chatPhotoCell = [tableView dequeueReusableCellWithIdentifier:@"ChatPhotoCell"];
        chatPhotoCell = [[ChatPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatPhotoCell"];
        [chatPhotoCell setData:message];
        NSLog(@"%@", chatPhotoCell);
        return chatPhotoCell;
    }
}

#pragma mark - UIScrollView+EmptyDataSet

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"envelope32"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;

    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        text = @"No messages.";
    } else {
        text = @"Chat";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [BOUtility fontTypeHeavyWithSize:20],
                                 NSForegroundColorAttributeName: [UIColor blackColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    text = @"There are no messages.You can send messages and your notes to your friends.You have to sign in first.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [BOUtility fontTypeBookWithSize:16],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return self.tableView.tableHeaderView.frame.size.height/3.0f;
}

- (void)write
{
    FriendViewController *vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Friend"];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];

    [self.navigationController presentViewController:nvc animated:YES completion:nil];
}

- (void)refresh
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
    [[BOParseManager sharedManager] fetchMessagesWithBlock:^(NSError *error){
        if (error) {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            [SVProgressHUD showErrorWithStatus:errorString];
        } else {
            [weakSelf.tableView reloadData];
            [SVProgressHUD dismiss];
        }
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
