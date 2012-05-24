//
//  FavoriteViewController.m
//  BFMan
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "FavoriteViewController.h"
#import "ClickHistoryManager.h"
#import "ItemWrapper.h"
#import "ItemCell.h"
#import "Item.h"
#import "TaobaoBrowserViewController.h"
#import "TaobaokeItem.h"
#import "NSString+URLConvert.h"
#import "ImageMemCache.h"

@interface FavoriteViewController ()

@end

@implementation FavoriteViewController
@synthesize helper, lastpageLoaded, cellTypes, itemIds, itemIdsLastPage, itemWrappers, loadingCell, needToScroll, indexOpened;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.helper = [[TBHelper alloc] init];
        self.needToScroll = NO;
        self.indexOpened = -1;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[ImageMemCache sharedImageMemCache] clearCache];
}

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
    
    self.title = @"个人收藏";
}

- (void)viewDidUnload
{
    self.needToScroll = YES;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([cellTypes count] == 0) {
        self.lastpageLoaded = 0;
        self.itemIdsLastPage = [[ClickHistoryManager defautManager] getClickHistoryAtPage:lastpageLoaded];
        if (itemIdsLastPage == nil) {
            return;
        }
        self.itemIds = [itemIdsLastPage mutableCopy];
        helper.delegate = self;
        [helper getTaobaokeItemsForItems:itemIds];
    }
    
    if (needToScroll) {
        self.needToScroll = NO;
        unsigned int *idx = (unsigned int *)malloc(2 * sizeof(unsigned int));
        idx[0] = 0;
        idx[1] = indexOpened;
        NSIndexPath *path = [[NSIndexPath alloc] initWithIndexes:idx length:2];
        free(idx);
        [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellType cellType = [[cellTypes objectAtIndex:indexPath.row] intValue];
    if (cellType == CELL_DATA) {
        static NSString *CellIdentifier = @"Cell";
        ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        // Configure the cell...
        
        NSNumber *itemId = [itemIds objectAtIndex:indexPath.row];
        ItemWrapper *itemWrapper = [itemWrappers objectForKey:[NSString stringWithFormat:@"%@", itemId]];
        Item *item = itemWrapper.item;
        [cell setupCellWithTitle:item.title pic:item.picUrl price:item.price];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (cellType == CELL_MORE) {
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


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    CellType cellType = [[cellTypes objectAtIndex:indexPath.row] intValue];
    if (cellType == CELL_DATA) {
        return YES;
    } else {
        return NO;
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.cellTypes removeObjectAtIndex:indexPath.row];
        [self.itemIds removeObjectAtIndex:indexPath.row];
        [[ClickHistoryManager defautManager] deleteHistoryAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}



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
    self.indexOpened = indexPath.row;
    CellType cellType = [[cellTypes objectAtIndex:indexPath.row] intValue];
    if (cellType == CELL_DATA) {
        NSNumber *itemId = [itemIds objectAtIndex:indexPath.row];
        ItemWrapper *itemWrapper = [itemWrappers objectForKey:[NSString stringWithFormat:@"%@", itemId]];
        Item *item = itemWrapper.item;
        TaobaokeItem *tbkItem = itemWrapper.tbkItem;
        
        TaobaoBrowserViewController *browser = [[TaobaoBrowserViewController alloc] initWithNibName:@"TaobaoBrowserViewController" bundle:nil];
        browser.itemId = itemId;
        browser.picUrl = [NSString stringWithFormat:@"%@_310x310.jpg", item.picUrl];
        if (tbkItem) {
            browser.itemUrl = [tbkItem.clickUrl newClickUrlForItemId:itemId];
        } else {
            browser.itemUrl = item.detailUrl;
        }
        browser.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:browser animated:YES];
    }
}

- (void)loadMoreData {
    self.lastpageLoaded ++;
    self.itemIdsLastPage = [[ClickHistoryManager defautManager] getClickHistoryAtPage:lastpageLoaded];
    if (itemIdsLastPage == nil) {
        return;
    }
    [self.itemIds addObjectsFromArray:itemIdsLastPage];
    [helper getTaobaokeItemsForItems:itemIdsLastPage];
}

- (void)helperFailed:(NSString *)msg {
    
}

- (void)helperFinishedWith:(id)obj {
    if (lastpageLoaded == 0) {
        self.itemWrappers = (NSMutableDictionary *)obj;
        self.cellTypes = [[NSMutableArray alloc] initWithCapacity:itemIds.count + 1];
        for (NSNumber *iid in itemIds) {
            [cellTypes addObject:[NSNumber numberWithInt:CELL_DATA]];
        }
    } else {
        [cellTypes removeLastObject];
        [itemWrappers addEntriesFromDictionary:(NSDictionary *)obj];
        for (NSNumber *iid in itemIdsLastPage) {
            [cellTypes addObject:[NSNumber numberWithInt:CELL_DATA]];
        }
    }
    if (itemIdsLastPage.count % 20 == 0 && itemIdsLastPage.count != 0) {
        [cellTypes addObject:[NSNumber numberWithInt:CELL_MORE]];
    }
    [self.tableView reloadData];
}

@end
