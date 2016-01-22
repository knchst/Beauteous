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
#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+REFrostedViewController.h"

@interface MenuViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
    self.tableView.separatorInset = UIEdgeInsetsZero;
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
        [self headerView];
    } else {
        self.tableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 92.0f)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, 0, 24)];
            label.text = @"Hi, there!";
            label.font = [BOUtility fontTypeBookWithSize:30];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];
            [label sizeToFit];
            label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            
            [view addSubview:label];
            
            view;
        });
    }
}

- (void)changeProfileImage
{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [[UIAlertController alloc] init];
    
    UIAlertAction *changeAvatar = [UIAlertAction actionWithTitle:@"Change Avatar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){

        [weakSelf showImagePicker];
    }];
    
    UIAlertAction *logout = [UIAlertAction actionWithTitle:@"Sign Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
        [PFUser logOutInBackgroundWithBlock:^(NSError *error){
            
            UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:[[BOUtility storyboard] instantiateViewControllerWithIdentifier:@"All"]];
            weakSelf.frostedViewController.contentViewController = vc;
            [weakSelf.frostedViewController hideMenuViewController];
        }];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
    }];
    
    [alert addAction:changeAvatar];
    [alert addAction:logout];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)headerView
{
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 164.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 80, 80)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 40.0;
        imageView.layer.borderColor = [UIColor blackColor].CGColor;
        imageView.layer.borderWidth = 1.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeProfileImage)];
        imageView.userInteractionEnabled = YES;
        imageView.gestureRecognizers = @[gesture];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 0, 24)];
        
        PFUser *currentUser = [PFUser currentUser];
        label.text = [NSString stringWithFormat:@"Hi, %@", currentUser.username];
        label.font = [BOUtility fontTypeBookWithSize:22];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        
        view;
    });
    
    PFFile *file = [PFUser currentUser][@"avatar"];
    [self reloadAvatarWithURL:file.url];
}

- (void)showImagePicker
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        
    } else {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Please allow Beauteous to use your PhotoLibrary"
                                                                    message:@""
                                                             preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                             }];
        UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                               }];
        [ac addAction:cancelAction];
        [ac addAction:settingsAction];
        
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    NSData *imageData = [BOUtility resizeImageWithImage:info[UIImagePickerControllerOriginalImage]];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:@"Uploading.."];
    
    PFQuery *query= [PFUser query];
    
    [query whereKey:@"username" equalTo:[[PFUser currentUser] username]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error){
        
        PFFile *file = [PFFile fileWithData:imageData];
        user[@"avatar"] = file;
        
        [user saveInBackgroundWithBlock:^(BOOL finished, NSError *error){
            [weakSelf reloadAvatarWithURL:file.url];
            [[PFUser currentUser] fetchInBackground];
            [SVProgressHUD dismiss];
        }];
        
        if (error) {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            [SVProgressHUD showErrorWithStatus:errorString];
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadAvatarWithURL:(NSString*)url
{
    __weak typeof(self) weakSelf = self;
    UIImageView *imageView = weakSelf.tableView.tableHeaderView.subviews[0];
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
        if (image == nil) {
            imageView.image = [UIImage imageNamed:@"Icon-76@2x"];
        } else {
            imageView.image = image;
        }
    }];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
}

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
        NSArray *titles = @[@"All", @"Starred", @"Chat", @"Trash", @"Settings"];
        NSArray *icons = @[
                           [UIImage imageNamed:@"Note"],
                           [UIImage imageNamed:@"Star"],
                           [UIImage imageNamed:@"Message"],
                           [UIImage imageNamed:@"Trash"],
                           [UIImage imageNamed:@"Settings"]];
        cell.textLabel.font = [BOUtility fontTypeMediumWithSize:18];
        cell.textLabel.text = titles[indexPath.row];
        cell.imageView.image = icons[indexPath.row];
    } else {
        
    }
    
    return cell;
}
 
@end
