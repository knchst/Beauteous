//
//  SettingsViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/4/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "SettingsViewController.h"
#import "BOUtility.h"
#import "EDHFontSelector.h"
#import "AboutViewController.h"
#import "BOConst.h"
#import "Parse.h"

#import "ComposeViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController {
    NSArray *_menuArray;
}

/*
 # Setting Lists
 
 - Export PDF
 - Style
    - Font Size
    - Font
 - Use Touch ID
 - Support
 - About
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PFUser logOut];
    
    self.title = @"Settings";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);

    _menuArray = @[@"Export as PDF", @"Style", @"Support", @"About"];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:BO_CELL];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BO_CELL];
    }
    
    [self configureCell:cell andIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell andIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.textLabel.font = [BOUtility fontTypeBookWithSize:20];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = _menuArray[indexPath.row];
    
    UIImage *image;
    
    if (indexPath.row == 0) {
        image = [UIImage imageNamed:BO_ICON_PDF];
    } else if (indexPath.row == 1) {
        image = [UIImage imageNamed:BO_ICON_FONT];
    } else if (indexPath.row == 2) {
        image = [UIImage imageNamed:BO_ICON_SUPPORT];
    } else if (indexPath.row == 3) {
        image = [UIImage imageNamed:BO_ICON_ABOUT];
    }
    
    cell.imageView.image = image;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [BOUtility screenSize].size.height;
    CGFloat width = [BOUtility screenSize].size.width;
    CGFloat cellHeight;
    
    if (height > width) {
        cellHeight = (height - width) / 4;
    } else if (height < width) {
        cellHeight = (width - height) / 4;
    }
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc;
    if (indexPath.row == 0) {
        vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"PDF"];
    } else if (indexPath.row == 1) {
        [self.navigationController presentViewController:[[EDHFontSelector sharedSelector] settingsNavigationController] animated:YES completion:nil];
    } else if (indexPath.row == 2) {
        //vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Support"];
        NSURL *URL = [NSURL URLWithString:@"https://www.facebook.com/stknch"];
        [[UIApplication sharedApplication] openURL:URL];
    } else if (indexPath.row == 3) {
        vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"About"];
    }

    self.navigationItem.backBarButtonItem = [BOUtility blankBarButton];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
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
