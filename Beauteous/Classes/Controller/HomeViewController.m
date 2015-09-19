//
//  HomeViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/28/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "HomeViewController.h"
#import "ComposeViewController.h"
#import "AllViewController.h"
#import "BOConst.h"
#import "BOUtility.h"
#import "Note.h"
#import "NoteManager.h"

#import "Realm.h"
#import "Parse.h"
#import "AMWaveTransition.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HomeViewController {
    NSArray* _menuArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Home";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _menuArray = @[@"All", @"Starred", @"Settings"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
        image = [UIImage imageNamed:BO_ICON_MENU];
    } else if (indexPath.row == 1) {
        image = [UIImage imageNamed:BO_ICON_STAR];
    } else if (indexPath.row == 2) {
        image = [UIImage imageNamed:BO_ICON_SETTINGS];
    }
    
    cell.imageView.image = image;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([BOUtility checkDevice]) {
        return 150;
    }
    
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
    UIViewController *vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:_menuArray[indexPath.row]];
    self.navigationItem.backBarButtonItem = [BOUtility blankBarButton];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)compose:(id)sender
{
    ComposeViewController* composeVC = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Compose"];
    [self.navigationController presentViewController:composeVC animated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation != UINavigationControllerOperationNone) {
        return [AMWaveTransition transitionWithOperation:operation andTransitionType:AMWaveTransitionTypeNervous];
    }
    return nil;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)dealloc
{
    [self.navigationController setDelegate:nil];
}

@end
