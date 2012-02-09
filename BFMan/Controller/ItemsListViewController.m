//
//  ItemsListViewController.m
//  BFMan
//
//  Created by  on 12-1-31.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "ItemsListViewController.h"
#import "HuabaoAuctionInfo.h"
#import "BFManConstants.h"
#import "ItemTableViewCell.h"
#import "TaobaokeItem.h"

@implementation ItemsListViewController
@synthesize server, huabaoAuctions, delegate;

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
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    self.server = [[TBServer alloc] initWithDelegate:self];
    NSMutableArray *itemIds = [[NSMutableArray alloc] initWithCapacity:huabaoAuctions.count];
    for (HuabaoAuctionInfo *auc in huabaoAuctions) {
        [itemIds addObject:auc.auctionId];
    }
    [server convertListOfTBKItems:itemIds];
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
    return [huabaoAuctions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    HuabaoAuctionInfo *auc = [huabaoAuctions objectAtIndex:indexPath.row];
    cell.item = auc.tbkItem;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupCellContents];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

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
    HuabaoAuctionInfo *auc = [huabaoAuctions objectAtIndex:indexPath.row];
    if (auc == nil) {
        return;
    }
    [delegate performSelector:@selector(openBrowser:) withObject:auc.tbkItem];
}

#pragma mark - TBServerDelegate
- (void)requestFailed:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE_NOTIFY
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"好"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)requestFinished:(id)data {
    NSDictionary *res = (NSDictionary *)data;
    NSArray *tbkItems = [res objectForKey:@"items"];
    if (tbkItems == nil) {
        [self.tableView reloadData];
        return;
    }
    for (HuabaoAuctionInfo *auc in huabaoAuctions) {
        for (TaobaokeItem *tbk in tbkItems) {
            if ([auc.auctionId isEqualToNumber:tbk.itemID]) {
                auc.tbkItem = tbk;
            }
        }
    }
    
    // delete the HuabaoAuctionInfo items which has no corresponding Taobaoke item
    NSIndexSet *idxToRemove = [huabaoAuctions indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        HuabaoAuctionInfo *auc = (HuabaoAuctionInfo *)obj;
        if (auc.tbkItem == nil) {
            return YES;
        } else
            return NO;
    }];
    if (idxToRemove.count > 0) {
        [huabaoAuctions removeObjectsAtIndexes:idxToRemove];
        CGRect oldFrame = self.tableView.frame;
        self.tableView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, huabaoAuctions.count * 80);
    }
    
    [self.tableView reloadData];
}

@end
