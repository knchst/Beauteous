//
//  MenuViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 1/18/16.
//  Copyright © 2016 Kenichi Saito. All rights reserved.
//

#import "MenuViewController.h"
#import "AllViewController.h"
#import "StarredViewController.h"
#import "TrashViewController.h"
#import "SettingsViewController.h"
#import "BOUtility.h"

#import "Parse.h"
#import "UIViewController+REFrostedViewController.h"

@interface MenuViewController ()
@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = self.view.frame;
    
    self.tableView.backgroundView = blurEffectView;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        self.tableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 50.0;
            imageView.layer.borderColor = [UIColor blackColor].CGColor;
            imageView.layer.borderWidth = 1.0f;
            imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
            imageView.layer.shouldRasterize = YES;
            imageView.clipsToBounds = YES;
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
            
            PFUser *currentUser = [PFUser currentUser];
            if (currentUser) {
                label.text = [NSString stringWithFormat:@"Hi, %@", currentUser.username];
            } else {
                label.text = @"Welcome back.";
            }
            
            label.font = [BOUtility fontTypeBookWithSize:22];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            [label sizeToFit];
            label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            
            [view addSubview:imageView];
            [view addSubview:label];
            
            view;
        });
    } else {
        self.tableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 92.0f)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, 0, 24)];
            label.text = @"Beauteous";
            label.font = [BOUtility fontTypeMediumWithSize:30];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            [label sizeToFit];
            label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            
            [view addSubview:label];
            
            view;
        });
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (sectionIndex == 0)
//        return nil;
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
//    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
//    label.text = @"Friends Online";
//    label.font = [UIFont systemFontOfSize:15];
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [label sizeToFit];
//    [view addSubview:label];
//    
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
//{
//    if (sectionIndex == 0)
//        return 0;
//    
//    return 34;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UINavigationController *vc = [[UINavigationController alloc] init];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        vc.viewControllers = @[[[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"All"]];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        vc.viewControllers = @[[[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Starred"]];
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        vc.viewControllers = @[[[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Chats"]];
    } else if (indexPath.section == 0 && indexPath.row == 3) {
        vc.viewControllers = @[[[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Trash"]];
    } else if (indexPath.section == 0 && indexPath.row == 4) {
        vc.viewControllers = @[[[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Settings"]];
    }
    
    self.frostedViewController.contentViewController = vc;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"All", @"Starred", @"Chats", @"Trash", @"Settings"];
        cell.textLabel.font = [BOUtility fontTypeBookWithSize:18];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        
    }
    
    return cell;
}
 
@end
