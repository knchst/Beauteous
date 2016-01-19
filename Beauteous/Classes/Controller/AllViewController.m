//
//  AllViewController.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "AppDelegate.h"
#import "AllViewController.h"
#import "PreviewViewController.h"
#import "BOUtility.h"
#import "BOConst.h"
#import "Note.h"
#import "NoteManager.h"
#import "AllTableViewCell.h"
#import "PhotoAllTableViewCell.h"
#import "DetailViewController.h"
#import "SettingsViewController.h"
#import "ComposeViewController.h"

#import "MCSwipeTableViewCell.h"
#import "UIScrollView+EmptyDataSet.h"

@interface AllViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, UINavigationControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchViewController;
@property (strong, nonatomic) RLMResults *searchResults;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation AllViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"All";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 0);
    self.tableView.layoutMargins = UIEdgeInsetsMake(0, 8, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setUpSearchViewController];
    
//    self.edgesForExtendedLayout = UIRectEdgeAll;
//    self.extendedLayoutIncludesOpaqueBars = YES;
//    self.definesPresentationContext = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Pen"] style:UIBarButtonItemStylePlain target:self action:@selector(write)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NoteManager sharedManager] fetchAllNotes];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    if (self.searchViewController.active) {
        self.searchViewController.active = NO;
        [self.searchViewController.searchBar removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.navigationController setDelegate:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = keyboardFrame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = 0;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchViewController.active) {
        return self.searchResults.count;
    }
    
    return [NoteManager sharedManager].notes.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Note *note = nil;
    
    if (self.searchViewController.active) {
        note = self.searchResults[indexPath.row];
    } else {
        note = [NoteManager sharedManager].notes[indexPath.row];
    }
    
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
    Note *note = nil;
    
    if (self.searchViewController.active) {
        note = self.searchResults[indexPath.row];
    } else {
        note = [NoteManager sharedManager].notes[indexPath.row];
    }
    
    [cell setDate:note];
    
    __weak AllViewController *weakSelf = self;
    
    UIImage *image = [UIImage imageNamed:BO_ICON_STAR];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImageView *starImage = [[UIImageView alloc] initWithImage:image];
    
    if (note.starred) {
        starImage.tintColor = [UIColor blackColor];
    } else {
        starImage.tintColor = [BOUtility yellowColor];
    }
    
    [cell setSwipeGestureWithView:starImage
                            color:[UIColor whiteColor]
                             mode:MCSwipeTableViewCellModeSwitch
                            state:MCSwipeTableViewCellState1
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      // Update Method
                      
                      [[NoteManager sharedManager] starringNote:note];
                      [weakSelf.tableView reloadData];
                      
    }];
    
    UIImageView *deleteImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BO_ICON_TRASH]];

    [cell setSwipeGestureWithView:deleteImage
                            color:[UIColor whiteColor]
                             mode:MCSwipeTableViewCellModeSwitch
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      
                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete?" message:@"Are you sure want to delete the note?" preferredStyle:UIAlertControllerStyleAlert];
                      UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                          [alert dismissViewControllerAnimated:YES completion:nil];
                      }];
                      UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                          [[NoteManager sharedManager] deleteObject:note];
                          [weakSelf.tableView reloadData];
                      }];
                      
                      [alert addAction:noAction];
                      [alert addAction:yesAction];
                      
                      [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)configurePhotoCell:(PhotoAllTableViewCell*)cell andIndexPath:(NSIndexPath *)indexPath
{
    Note *note = nil;
    
    if (self.searchViewController.active) {
        note = self.searchResults[indexPath.row];
    } else {
        note = [NoteManager sharedManager].notes[indexPath.row];
    }
    
    [cell setDate:note];
    
    __weak AllViewController *weakSelf = self;
    
    UIImage *image = [UIImage imageNamed:BO_ICON_STAR];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImageView *starImage = [[UIImageView alloc] initWithImage:image];
    
    if (note.starred) {
        starImage.tintColor = [UIColor blackColor];
    } else {
        starImage.tintColor = [BOUtility yellowColor];
    }
    
    [cell setSwipeGestureWithView:starImage
                            color:[UIColor whiteColor]
                             mode:MCSwipeTableViewCellModeSwitch
                            state:MCSwipeTableViewCellState1
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      // Update Method
                      
                      [[NoteManager sharedManager] starringNote:note];
                      [weakSelf.tableView reloadData];
                      
                  }];
    
    UIImageView *deleteImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BO_ICON_TRASH]];
    
    [cell setSwipeGestureWithView:deleteImage
                            color:[UIColor whiteColor]
                             mode:MCSwipeTableViewCellModeSwitch
                            state:MCSwipeTableViewCellState3
                  completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                      
                      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete?" message:@"Are you sure want to delete the note?" preferredStyle:UIAlertControllerStyleAlert];
                      UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                          [alert dismissViewControllerAnimated:YES completion:nil];
                      }];
                      UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                          [[NoteManager sharedManager] deleteObject:note];
                          [weakSelf.tableView reloadData];
                      }];
                      
                      [alert addAction:noAction];
                      [alert addAction:yesAction];
                      
                      [weakSelf presentViewController:alert animated:YES completion:nil];
                  }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Note *note;
    
    if (self.searchViewController.active) {
        note = self.searchResults[indexPath.row];
    } else {
        note = [NoteManager sharedManager].notes[indexPath.row];
    }
    
    NSLog(@"%@", note);
        
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

#pragma mark - UIScrollView+EmptyDataSet

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.searchViewController.active) {
        return [UIImage imageNamed:@"Question-100"];
    }
    return [UIImage imageNamed:@"Pen-100"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    if (self.searchViewController.active) {
        text = @"No results.";
    } else {
        text = @"Let's write your first note.";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [BOUtility fontTypeHeavyWithSize:20],
                                 NSForegroundColorAttributeName: [UIColor blackColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    if (self.searchViewController.active) {
        text = [NSString stringWithFormat:@"We couldn’t find any notes matching \"%@\"", self.searchViewController.searchBar.text];
    } else {
        text = @"All notes you write will display here.To swipe right can star note and to swipe left can delete note.";
    }
    
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

#pragma mark - SearchViewController

- (void)setUpSearchViewController
{
    self.searchViewController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchViewController.searchResultsUpdater = self;
    self.searchViewController.delegate = self;
    self.searchViewController.dimsBackgroundDuringPresentation = NO;
    self.searchViewController.searchBar.backgroundColor = [UIColor clearColor];
    self.searchViewController.searchBar.tintColor = [UIColor blackColor];
    self.searchViewController.searchBar.barTintColor = [UIColor whiteColor];
    self.searchViewController.searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.searchViewController.searchBar.layer.borderWidth = 1.0;
    self.searchViewController.searchBar.placeholder = @"Tap to Search";
    self.searchViewController.searchBar.delegate = self;
    [self.searchViewController.searchBar sizeToFit];
    
    self.tableView.tableHeaderView = self.searchViewController.searchBar;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.searchResults = nil;
    NSString *searchString = [NSString stringWithFormat:@"planeString CONTAINS[c] '%@'", self.searchViewController.searchBar.text];
    NSLog(@"%@", searchString);
    self.searchResults = [[NoteManager sharedManager].notes objectsWhere:searchString];
    [self.tableView reloadData];
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    searchController.searchBar.placeholder = @"Search";
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    searchController.searchBar.placeholder = @"Tap to Search";
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)write
{
    ComposeViewController *vc = [[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"Compose"];
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
