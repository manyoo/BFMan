//
//  MoreInfoViewController.m
//  BFMan
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "MoreInfoViewController.h"
#import "BFManConstants.h"
#import "HelpPhotoViewController.h"
#import "UMSNSService.h"
#import "JSImageLoaderCache.h"

@implementation MoreInfoViewController
@synthesize snsType, hud;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar.png"] forBarMetrics:UIBarMetricsDefault];
    } else {
        UIImageView *navImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navBar.png"]];
        navImgView.frame = CGRectMake(0, 0, 320, 44);
        [self.navigationController.navigationBar insertSubview:navImgView atIndex:0];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *uid = [UMSNSService getLocalUid:UMShareToTypeSina];
            if (uid) {
                NSString *nick = [UMSNSService getNicknameWithAppkey:UMENG_APP_KEY_STR
                                                                 uid:uid
                                                            platform:UMShareToTypeSina
                                                               error:nil];
                cell.textLabel.text = [NSString stringWithFormat:@"当前用户: %@", nick];
            } else {
                cell.textLabel.text = @"设置新浪微博账户";
            }
            cell.imageView.image = [UIImage imageNamed:@"Sina.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else if (indexPath.row == 1) {
            NSString *uid = [UMSNSService getLocalUid:UMShareToTypeTenc];
            if (uid) {
                NSString *nick = [UMSNSService getNicknameWithAppkey:UMENG_APP_KEY_STR
                                                                 uid:uid
                                                            platform:UMShareToTypeTenc
                                                               error:nil];
                cell.textLabel.text = [NSString stringWithFormat:@"当前用户: %@", nick];
            } else {
                cell.textLabel.text = @"设置腾讯微博账户";
            }
            cell.imageView.image = [UIImage imageNamed:@"Tencent.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            NSString *uid = [UMSNSService getLocalUid:UMShareToTypeRenr];
            if (uid) {
                NSString *nick = [UMSNSService getNicknameWithAppkey:UMENG_APP_KEY_STR
                                                                 uid:uid
                                                            platform:UMShareToTypeRenr
                                                               error:nil];
                cell.textLabel.text = [NSString stringWithFormat:@"当前用户: %@", nick];
            } else {
                cell.textLabel.text = @"设置人人网账户";
            }
            cell.imageView.image = [UIImage imageNamed:@"RenRen.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (indexPath.section == 1) {
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"清除缓存";
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *uid = [UMSNSService getLocalUid:UMShareToTypeSina];
            if (uid) {
                NSString *nick = [UMSNSService getNicknameWithAppkey:UMENG_APP_KEY_STR
                                                                 uid:uid
                                                            platform:UMShareToTypeSina
                                                               error:nil];
                NSString *msg = [NSString stringWithFormat:@"确定退出新浪微博账户\"%@\"?", nick];
                self.snsType = SNS_SINA;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:@"是的"
                                                      otherButtonTitles:@"取消", nil];
                [alert show];
            } else {
                [UMSNSService oauthInController:self
                                         appkey:UMENG_APP_KEY_STR
                                       platform:UMShareToTypeSina];
            }
        } else if (indexPath.row == 1) {
            NSString *uid = [UMSNSService getLocalUid:UMShareToTypeTenc];
            if (uid) {
                NSString *nick = [UMSNSService getNicknameWithAppkey:UMENG_APP_KEY_STR
                                                                 uid:uid
                                                            platform:UMShareToTypeTenc
                                                               error:nil];
                NSString *msg = [NSString stringWithFormat:@"确定退出腾讯微博账户\"%@\"?", nick];
                self.snsType = SNS_TENC;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:@"是的"
                                                      otherButtonTitles:@"取消", nil];
                [alert show];
            } else {
                [UMSNSService oauthInController:self
                                         appkey:UMENG_APP_KEY_STR
                                       platform:UMShareToTypeTenc];
            }
        } else {
            NSString *uid = [UMSNSService getLocalUid:UMShareToTypeRenr];
            if (uid) {
                NSString *nick = [UMSNSService getNicknameWithAppkey:UMENG_APP_KEY_STR
                                                                 uid:uid
                                                            platform:UMShareToTypeRenr
                                                               error:nil];
                NSString *msg = [NSString stringWithFormat:@"确定退出人人网账户\"%@\"?", nick];
                self.snsType = SNS_RENR;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:@"是的"
                                                      otherButtonTitles:@"取消", nil];
                [alert show];
            } else {
                [UMSNSService oauthInController:self
                                         appkey:UMENG_APP_KEY_STR
                                       platform:UMShareToTypeRenr];
            }
        }
        [self.tableView reloadData];
    } else if (indexPath.section == 1) {
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.labelText = @"正在清除...";
        [self.view addSubview:hud];
        [hud showWhileExecuting:@selector(clearCaches) onTarget:self withObject:nil animated:YES];
    }
}

- (void)clearCaches {
    [[JSImageLoaderCache sharedCache] trimDiskCacheFilesToZero:hud];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (snsType == SNS_SINA) {
            [UMSNSService writeOffAccounts:UMShareToTypeSina];
        } else if (snsType == SNS_TENC) {
            [UMSNSService writeOffAccounts:UMShareToTypeTenc];
        } else {
            [UMSNSService writeOffAccounts:UMShareToTypeRenr];
        }
        [self.tableView reloadData];
    }
}

@end
