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
#import "BOUtility.h"
#import "Note.h"

#import "Realm.h"
#import "Parse.h"
#import "AMWaveTransition.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
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
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor blackColor];
    
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
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [BOUtility fontTypeHeavyWithSize:30];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    [self configureCell:cell andIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell andIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = _menuArray[indexPath.row];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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

- (void)dealloc
{
    [self.navigationController setDelegate:nil];
}

@end
