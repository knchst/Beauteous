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

@interface AboutViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation AboutViewController {
    UITableView *_tableView;
    NSArray *_menuArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"About";
    
    _menuArray = @[@"Licenses"];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    _tableView = [[UITableView alloc] initWithFrame:rect];
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
    return (height - width) / 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarkViewController *vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Mark"];
    vc.string = [self license];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
