//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "LeftViewController.h"
#import "AllViewController.h"
#import "AppDelegate.h"
#import "LeftViewCell.h"
#import "MainViewController.h"
#import "BOUtility.h"

@interface LeftViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _titlesArray = @[@"Beauteous",
                     @"",
                     @"All",
                     @"Starred",
                     @"Trash",
                     @"",
                     @"Settings"];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(20.f, 0.f, 20.f, 0.f);
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark -

- (void)openLeftView
{
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell"];
    
    cell.textLabel.text = _titlesArray[indexPath.row];
    cell.separatorView.hidden = YES;
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 5) {
        cell.userInteractionEnabled = NO;
        cell.textLabel.font = [BOUtility fontTypeBookWithSize:25];
    } else {
        cell.userInteractionEnabled = YES;
        cell.textLabel.font = [BOUtility fontTypeBookWithSize:20];
        
        if (indexPath.row == 2) {
            cell.imageView.image = [[UIImage imageNamed:@"Note"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else if (indexPath.row == 3) {
            cell.imageView.image = [[UIImage imageNamed:@"Star"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else if (indexPath.row == 4) {
            cell.imageView.image = [[UIImage imageNamed:@"Trash"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else if (indexPath.row == 6) {
            cell.imageView.image = [[UIImage imageNamed:@"Settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }
    
    cell.imageView.tintColor = [UIColor whiteColor];
    cell.tintColor = _tintColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 5) return 22.f;
    else return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index is %ld", (long)indexPath.row);
    
    if (indexPath.row != 0 && indexPath.row != 5) {
        
        UIViewController *viewController;
        
        if (indexPath.row == 2) {
            viewController = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"All"];
        } else if (indexPath.row == 3) {
            viewController = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Starred"];
        } else if (indexPath.row == 4) {
            viewController = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Trash"];
        } else if (indexPath.row == 6) {
            viewController = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Settings"];
        }
        
        [kNavigationController pushViewController:viewController animated:YES];
        [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
    }
}

@end
