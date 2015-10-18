//
//  StarredViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/4/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "StarredViewController.h"
#import "Note.h"
#import "NoteManager.h"
#import "AllTableViewCell.h"
#import "PhotoAllTableViewCell.h"
#import "DetailViewController.h"
#import "SettingsViewController.h"
#import "ComposeViewController.h"
#import "BOUtility.h"
#import "BOConst.h"

#import "UIScrollView+EmptyDataSet.h"
#import "AMWaveTransition.h"

#import "MainViewController.h"
#import "AppDelegate.h"

@interface StarredViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation StarredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Starred";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 0);
    self.tableView.layoutMargins = UIEdgeInsetsMake(0, 8, 0, 0);
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Menu"] style:UIBarButtonItemStylePlain target:self action:@selector(openLeftView)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NoteManager sharedManager] fetchAllStarredNotes];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
}

- (void)dealloc
{
    [self.navigationController setDelegate:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [NoteManager sharedManager].notes.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [NoteManager sharedManager].notes[indexPath.row];
    
    if ([note.photoUrl isEqualToString:@""]) {
        
        AllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BO_CELL];
        if (cell == nil) {
            cell = [[AllTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BO_CELL];
        }
        [self configureCell:cell andIndexPath:indexPath];
        
        return cell;
    }
    
    PhotoAllTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BO_CELL_PHOTO];
    if (cell == nil) {
        cell = [[PhotoAllTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BO_CELL_PHOTO];
    }
    [self configurePhotoCell:cell andIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(AllTableViewCell*)cell andIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [NoteManager sharedManager].notes[indexPath.row];
    [cell setDate:note];
}

- (void)configurePhotoCell:(PhotoAllTableViewCell*)cell andIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [NoteManager sharedManager].notes[indexPath.row];
    [cell setDate:note];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Note *note = [NoteManager sharedManager].notes[indexPath.row];
    
    DetailViewController *detailVC = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Detail"];
    detailVC.note = note;
    self.navigationItem.backBarButtonItem = [BOUtility blankBarButton];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([BOUtility checkDevice]) {
        return 150;
    }
    
    return 100;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"Star-100"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Let's star your note.";
    
    NSDictionary *attributes = @{NSFontAttributeName: [BOUtility fontTypeHeavyWithSize:20],
                                 NSForegroundColorAttributeName: [UIColor blackColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Your Starred notes will display here.You can star your notes for swipe right.";
    
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

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation != UINavigationControllerOperationNone) {
        // Return your preferred transition operation
        return [AMWaveTransition transitionWithOperation:operation];
    }
    return nil;
}

#pragma mark -

- (void)openLeftView
{
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
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
