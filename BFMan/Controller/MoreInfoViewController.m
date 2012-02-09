//
//  MoreInfoViewController.m
//  BFMan
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "MoreInfoViewController.h"
#import "BlogClient.h"
#import "WeiboManager.h"
#import "BFManConstants.h"

@implementation MoreInfoViewController

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)getWeiboUserName {
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSURL *documentDir;
    if ([urls count] > 0) {
        documentDir = [urls objectAtIndex:0];    
        
        NSURL *fileUrl = [NSURL URLWithString:WEIBO_USER_FILE relativeToURL:documentDir];
        
        BOOL hasFile = [[NSFileManager defaultManager] fileExistsAtPath:[fileUrl path]];
        if (hasFile) {
            NSString *data = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:nil];
            NSArray *rows = [data componentsSeparatedByString:@"\n"];
            return [rows objectAtIndex:1];
        }
    }
    return nil;
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
        BlogClient *blog = [WeiboManager getBlogClient];
        if ([blog isAuthorized]) {
            cell.textLabel.text = [NSString stringWithFormat:@"微博账号:%@", [self getWeiboUserName]];
        } else
            cell.textLabel.text = @"设置新浪微博账户";
        cell.imageView.image = [UIImage imageNamed:@"weibo_logo.png"];
        cell.accessoryType = UITableViewCellAccessoryNone;
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
        BlogClient *blog = [WeiboManager getBlogClient];
        if ([blog isAuthorized]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出"
                                                            message:[NSString stringWithFormat:@"是否确认退出微博账户\"%@\"?", [self getWeiboUserName]]
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"退出", nil];
            [alert show];
        } else {
            UIViewController *weiboLogin = [blog getOAuthViewController:self];
            [self presentModalViewController:weiboLogin animated:YES];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        
        NSURL *documentDir;
        if ([urls count] > 0) {
            documentDir = [urls objectAtIndex:0];    
            
            NSURL *fileUrl = [NSURL URLWithString:WEIBO_USER_FILE relativeToURL:documentDir];
            
            BOOL hasFile = [[NSFileManager defaultManager] fileExistsAtPath:[fileUrl path]];
            if (hasFile) {
                [[NSFileManager defaultManager] removeItemAtURL:fileUrl error:nil];
            }
            
            NSURL *bfileUrl = [NSURL URLWithString:ACCESS_KEY_FILE relativeToURL:documentDir];
            BOOL bhasFile = [[NSFileManager defaultManager] fileExistsAtPath:[bfileUrl path]];
            if (bhasFile) {
                [[NSFileManager defaultManager] removeItemAtURL:bfileUrl error:nil];
            }
            BlogClient *blog = [WeiboManager getBlogClient];
            [blog setAccessKey:nil secret:nil];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - OAuthViewControllerDelegate
- (void)OAuthViewControllerOk:(NSString *)text {
    BlogClient *blog = [WeiboManager getBlogClient];
    NSString *uid = [blog.oauth userID];
    
    [blog show:@"" user_id:uid screen_name:@"" delegate:self onSuccess:@selector(getWeiboUser:dict:) onFail:@selector(weiboFailed:msg:)];
}

- (void)OAuthViewControllerCancel:(NSString *)text {
    
}

- (void)getWeiboUser:(NSNumber *)code dict:(NSDictionary *)userDict {
    BlogClient *blog = [WeiboManager getBlogClient];
    blog.user = [[WeiboUser alloc] initWithDictionary:userDict];
    
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSURL *documentDir;
    if ([urls count] > 0) {
        documentDir = [urls objectAtIndex:0];
        
        NSURL *fileUrl = [NSURL URLWithString:WEIBO_USER_FILE relativeToURL:documentDir];
        
        NSString *t = [NSString stringWithFormat:@"%@\n%@",blog.user.userId,blog.user.screen_name];
        [t writeToURL:fileUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    [self.tableView reloadData];
}

- (void)weiboFailed:(NSNumber *)code msg:(NSString *)str {
    
}

@end
