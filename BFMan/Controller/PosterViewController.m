//
//  PosterViewController.m
//  BFMan
//
//  Created by  on 12-1-22.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "PosterViewController.h"
#import "LoadingTableViewCell.h"
#import "ItemBigTableViewCell.h"
#import "HuaBao.h"
#import "BFManConstants.h"
#import "FullImageViewController.h"
#import "HuabaoAuctionInfo.h"

@implementation PosterViewController
@synthesize posters, refreshEnabled, multipageEnabled, cellTypes, refreshHeaderView, lastpageLoaded, reloading, allItemsReloading, loadingCell, server, apiType, huabaoPictures, selectedHuaBao, hud;

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
    self.tableView.allowsSelection = NO;
    
    if (refreshEnabled) {
        self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                             0.0f - self.tableView.bounds.size.height, 
                                                                                             self.view.frame.size.width, 
                                                                                             self.tableView.bounds.size.height)
                                                                   arrowImageName:@"blueArrow.png" 
                                                                        textColor:[UIColor grayColor]];
        refreshHeaderView.delegate = self;
        [self.tableView addSubview:refreshHeaderView];
        
        [refreshHeaderView refreshLastUpdatedDate];
    }
    if (multipageEnabled) {
        self.lastpageLoaded = 0;
    }
    self.posters = [[NSMutableArray alloc] init];
    self.cellTypes = [[NSMutableArray alloc] init];
    self.server = [[TBServer alloc] initWithDelegate:self];
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
    return [cellTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    CellType cellType = [[cellTypes objectAtIndex:indexPath.row] intValue];
    
    if (cellType == CELL_DATA) {
        if (indexPath.row % 2 == 0) {
            static NSString *CellIdentifier = @"SplitCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sperator.png"]];
                imgView.frame = CGRectMake(0, 0, 320, 8);
                [cell.contentView addSubview:imgView];
            }
            return cell;
        } else {
            static NSString *CellIdentifier = @"Cell";
            
            ItemBigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[ItemBigTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            HuaBao *huabao = [posters objectAtIndex:indexPath.row - 1];
            HuaBao *huabao2 = [posters objectAtIndex:indexPath.row];
            cell.itemLeft = huabao;
            cell.itemRight = huabao2;
            [cell setupCellContentsWithDelegate:self];
            return cell;
        }
    } else if (cellType == CELL_RELOAD) {
        static NSString *CellIdentifier = @"LoadingCell";
    
        LoadingTableViewCell *cell = self.loadingCell;
        if (cell == nil) {
            self.loadingCell = [[LoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = self.loadingCell;
        }
        [self loadMoreData];
        return cell;
    }
    return nil;
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
    CellType cellType = [[cellTypes objectAtIndex:indexPath.row] intValue];
    if (cellType == CELL_DATA) {
        if (indexPath.row % 2 == 0) {
            return 8;
        } else
            return 180;
    } else
        return 44;
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
}

- (void)reloadTableViewDataSource {
    self.reloading = YES;
    // call the model to reload data in subclass.
}

- (void)doneLoadingTableViewData {
    self.reloading = NO;
    [refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (refreshEnabled) {
        [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (refreshEnabled) {
        [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark - Refresh delegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    return reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
    return [NSDate date];
}

- (void)loadMoreData {
    
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
    if (apiType == API_GETPICTURE) {
        self.huabaoPictures = (NSArray *)data;
        self.apiType = API_GETAUCTION;
        [self.server getPosterAuctionInfos:selectedHuaBao.huabaoID];
    } else if (apiType == API_GETAUCTION) {
        NSArray *huabaoAuctions = (NSArray *)data;
        NSMutableDictionary *auctions = [[NSMutableDictionary alloc] initWithCapacity:huabaoPictures.count];
        for (HuabaoAuctionInfo *auc in huabaoAuctions) {
            NSMutableArray *item = [auctions objectForKey:[NSString stringWithFormat:@"%@", auc.picId]];
            if (item == nil) {
                item = [[NSMutableArray alloc] init];
            }
            [item addObject:auc];
            [auctions setValue:item forKey:[NSString stringWithFormat:@"%@", auc.picId]];
        }
        
        [self.hud hide:YES];
        
        FullImageViewController *imgViewController = [[FullImageViewController alloc] initWithNibName:@"FullImageViewController" bundle:nil];
        imgViewController.huabao = selectedHuaBao;
        imgViewController.huabaoPictures = huabaoPictures;
        imgViewController.huabaoAuctions = auctions;
        imgViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentModalViewController:imgViewController animated:YES];
    }
}


- (void)openHuabao:(HuaBao *)huabao {
    self.apiType = API_GETPICTURE;
    self.selectedHuaBao = huabao;
    
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:progressHUD];
    
    progressHUD.delegate = self;
    progressHUD.labelText = @"正在加载";
    
    self.hud = progressHUD;
    
    [progressHUD show:YES];
    [self.server getPosterDetail:huabao.huabaoID];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    self.hud = nil;
}

@end
