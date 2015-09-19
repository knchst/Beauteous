//
//  AboutViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/7/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "AboutViewController.h"
#import "BOUtility.h"
#import "MarkViewController.h"
#import "SettingsViewController.h"
#import "ComposeViewController.h"

#import "YALTabBarInteracting.h"

@interface AboutViewController () <UITableViewDataSource, UITableViewDelegate, YALTabBarInteracting>

@end

@implementation AboutViewController {
    UITableView *_tableView;
    NSArray *_menuArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"About";
    
    _menuArray = @[
                   @"What's Markdown?",
                   @"License"];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, rect.size.width, rect.size.height - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
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
    MarkViewController *vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Mark"];
    if (indexPath.row == 0) {
        vc.string = [self markdown];
        vc.title = _menuArray[indexPath.row];
    } else if (indexPath.row == 1) {
        vc.string = [self license];
    }
    vc.title = _menuArray[indexPath.row];
    self.navigationItem.backBarButtonItem = [BOUtility blankBarButton];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString*)license
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"License" ofType:@"txt"];
    NSError *error;
    NSString *text = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@", text);
    
    return text;
}

- (NSString*)markdown
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"markdown" ofType:@"txt"];
    NSError *error;
    NSString *text = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@", text);
    
    return text;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#define debug 1

#pragma mark - YALTabBarInteracting

- (void)tabBarViewWillCollapse {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewWillExpand {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewDidCollapse {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewDidExpand {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)extraLeftItemDidPress {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)extraRightItemDidPress {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    ComposeViewController *vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Compose"];
    self.navigationItem.backBarButtonItem = [BOUtility blankBarButton];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
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
