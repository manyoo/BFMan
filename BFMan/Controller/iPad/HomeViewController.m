//
//  HomeViewController.m
//  BFMan
//
//  Created by  on 12-5-28.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "HomeViewController.h"
#import "HuaBao.h"
#import "HuabaoAuctionInfo.h"
#import "HuabaoPicture.h"
#import "FullImageViewController.h"
#import "ItemBigiPadCell.h"
#import "ItemBigiPadCell2.h"
#import "LoadingTableViewCell.h"
#import "ImageMemCache.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize channelButton;
@synthesize tableView, server, apiType, listType, posters, hotPosters, allPosters, currentChannelId, loadingCell, lastpageLoaded, reloading, allItemsReloading, multipageEnabled, needToScroll, indexOpened, channelSelectionViewController, huabaoPictures, selectedHuaBao, refreshHeaderView, refreshEnabled, hasMoreData, popoverController;

- (void)initialize {
    self.server = [[TBServer alloc] initWithDelegate:self];
    self.listType = HOT_POSTERS;
    self.currentChannelId = [NSNumber numberWithInt:3];
    self.hasMoreData = NO;
    self.lastpageLoaded = 0;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)requestHot {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"HOT" forKey:@"appointed_type"];
    [params setValue:self.currentChannelId forKey:@"channel_ids"];
    [params setValue:@"20" forKey:@"re_num"];
    self.apiType = API_GETHOT;
    [self.server getAppointedPosters:params];
}

- (void)requestRecommend {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"RECOMMEND" forKey:@"appointed_type"];
    [params setValue:self.currentChannelId forKey:@"channel_ids"];
    [params setValue:@"20" forKey:@"re_num"];
    self.apiType = API_GETRECOMMEND;
    [self.server getAppointedPosters:params];
}

- (void)requestAllPostersOnPage:(NSInteger)p {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.currentChannelId forKey:@"channel_id"];
    [params setValue:@"20" forKey:@"page_size"];
    [params setValue:[NSNumber numberWithInt:p] forKey:@"page_no"];
    self.apiType = API_GETALL;
    [self.server getPosters:params];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView.allowsSelection = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                         0.0f - self.tableView.bounds.size.height, 
                                                                                         self.view.frame.size.width, 
                                                                                         self.tableView.bounds.size.height)
                                                               arrowImageName:@"blueArrow.png" 
                                                                    textColor:[UIColor grayColor]];
    refreshHeaderView.delegate = self;
    [self.tableView addSubview:refreshHeaderView];
    [refreshHeaderView refreshLastUpdatedDate];
    
    self.multipageEnabled = YES;
    self.lastpageLoaded = 0;
    
    if (listType == HOT_POSTERS) {
        self.posters = hotPosters;
    } else if (listType == ALL_POSTERS) {
        self.posters = allPosters;
    }
    
    self.channelSelectionViewController = [[ChannelSelectioniPadViewController alloc] initWithNibName:@"ChannelSelectioniPadViewController" bundle:nil];
    channelSelectionViewController.contentSizeForViewInPopover = CGSizeMake(100, 300);
    channelSelectionViewController.delegate = self;
    
    if (posters.count == 0) {
        if (listType == HOT_POSTERS) {
            [self requestHot];
        } else if (listType == ALL_POSTERS) {
            self.allItemsReloading = YES;
            [self requestAllPostersOnPage:(lastpageLoaded + 1)];
        }
    }
}

- (void)viewDidUnload
{
    [self setChannelButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.refreshHeaderView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[ImageMemCache sharedImageMemCache] clearCache];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UIInterfaceOrientation orient = self.interfaceOrientation;
    int count = posters.count;
    int c = 0;
    if (UIInterfaceOrientationIsPortrait(orient)) {
        c = count % 3 != 0 ? (count / 3) + 1 : count / 3;
    } else if (UIInterfaceOrientationIsLandscape(orient)) {
        c = count % 4 != 0 ? (count / 4) + 1 : count / 4;
    }
    if (listType == ALL_POSTERS && hasMoreData) {
        c++;
    }
    return c;
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    UIInterfaceOrientation orient = self.interfaceOrientation;
    int count = posters.count;
    int c = 0;
    if (UIInterfaceOrientationIsPortrait(orient)) {
        c = count % 3 != 0 ? (count / 3) + 1 : count / 3;
    } else if (UIInterfaceOrientationIsLandscape(orient)) {
        c = count % 4 != 0 ? (count / 4) + 1 : count / 4;
    }
    if (indexPath.row < c) {
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            static NSString *CellIdentifier = @"Cell";
            
            ItemBigiPadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[ItemBigiPadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSInteger count = posters.count;
            int i = indexPath.row * 3;
            
            HuaBao *huabao = [posters objectAtIndex:i];
            
            HuaBao *huabao2 = nil;
            if (i + 1 < count) {
                huabao2 = [posters objectAtIndex:i + 1];
            }
            HuaBao *huabao3 = nil;
            if (i + 2 < count) {
                huabao3 = [posters objectAtIndex:i + 2];
            }
            cell.item1 = huabao;
            cell.item2 = huabao2;
            cell.item3 = huabao3;
            [cell setupCellContentsWithDelegate:self];
            return cell;
        } else {
            static NSString *CellIdentifier = @"Cell2";
            
            ItemBigiPadCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[ItemBigiPadCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            NSInteger count = posters.count;
            int i = indexPath.row * 4;
            
            HuaBao *huabao = [posters objectAtIndex:i];
            HuaBao *huabao2 = nil;
            if (i + 1 < count) {
                huabao2 = [posters objectAtIndex:i + 1];
            }
            HuaBao *huabao3 = nil;
            if (i + 2 < count) {
                huabao3 = [posters objectAtIndex:i + 2];
            }
            HuaBao *huabao4 = nil;
            if (i + 3 < count) {
                huabao4 = [posters objectAtIndex:i + 3];
            }
            cell.item1 = huabao;
            cell.item2 = huabao2;
            cell.item3 = huabao3;
            cell.item4 = huabao4;
            [cell setupCellContentsWithDelegate:self];
            return cell;
        }
    } else {
        static NSString *CellIdentifier = @"LoadingCell";
        
        LoadingTableViewCell *cell = self.loadingCell;
        if (cell == nil) {
            self.loadingCell = [[LoadingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = self.loadingCell;
        }
        self.hasMoreData = NO;
        [self loadMoreData];
        return cell;
    }
    return nil;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIInterfaceOrientation orient = self.interfaceOrientation;
    int count = posters.count;
    int c = 0;
    if (UIInterfaceOrientationIsPortrait(orient)) {
        c = count % 3 != 0 ? (count / 3) + 1 : count / 3;
    } else if (UIInterfaceOrientationIsLandscape(orient)) {
        c = count % 4 != 0 ? (count / 4) + 1 : count / 4;
    }
    if (indexPath.row < c){
        return 250;
    } else
        return 44;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)changeType:(UISegmentedControl *)seg {
    self.listType = seg.selectedSegmentIndex;
    if (listType == HOT_POSTERS) {
        self.posters = hotPosters;
    } else if (listType == ALL_POSTERS) {
        self.posters = allPosters;
    }
    if (posters.count == 0) {
        if (listType == HOT_POSTERS) {
            [self requestHot];
        } else if (listType == ALL_POSTERS) {
            self.allItemsReloading = YES;
            [self requestAllPostersOnPage:(lastpageLoaded + 1)];
        }
    }
    [tableView reloadData];
}

- (IBAction)channelButtonClicked:(id)sender {
    self.popoverController = [[UIPopoverController alloc] initWithContentViewController:channelSelectionViewController];
    popoverController.popoverContentSize = CGSizeMake(100, 300);
    [popoverController presentPopoverFromBarButtonItem:channelButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
    self.allItemsReloading = NO;
    [self requestAllPostersOnPage:(lastpageLoaded + 1)];
}

#pragma mark - TBServerDelegate
- (void)requestFailed:(NSString *)msg {
    
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
                
        FullImageViewController *imgViewController = [[FullImageViewController alloc] initWithNibName:@"FullImageViewController" bundle:nil];
        [imgViewController setHuabao:selectedHuaBao pictures:huabaoPictures auctions:auctions];
        imgViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentModalViewController:imgViewController animated:YES];
    } else if (apiType == API_SEARCH) {
        if (lastpageLoaded == 1) {
            self.posters = (NSMutableArray *)data;
        } else {
            NSArray *newData = (NSArray *)data;
            [posters addObjectsFromArray:newData];
        }
        /*if (self.reloading) {
         [self doneLoadingTableViewData];
         }*/
        [self.tableView reloadData];
    } else if (self.apiType == API_GETHOT) {
        self.hotPosters = (NSMutableArray *)data;
        [self requestRecommend];
    } else if (self.apiType == API_GETRECOMMEND) {
        NSArray *newPosters = (NSArray *)data;
        [hotPosters addObjectsFromArray:newPosters];
        if (reloading) {
            [self doneLoadingTableViewData];
        }
        
        self.posters = hotPosters;
        
        [self.tableView reloadData];
    } else if (self.apiType == API_GETALL) {
        NSMutableArray *newItems = (NSMutableArray *)data;
        if (self.allItemsReloading) {
            self.allPosters = newItems;
            self.allItemsReloading = NO;
        } else {
            [allPosters addObjectsFromArray:newItems];
        }
        
        if (newItems.count % 20 == 0) {
            self.hasMoreData = YES;
        }
        self.lastpageLoaded ++;
        self.posters = allPosters;
        
        [self.tableView reloadData];
    }
}

- (void)openHuabao:(HuaBao *)huabao {
    
}

#pragma mark - UIPopoverController
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return YES;
}

- (void)channelSelected:(NSNumber *)channelId {
    [popoverController dismissPopoverAnimated:YES];
    self.currentChannelId = channelId;
    if (listType == HOT_POSTERS) {
        [self requestHot];
    } else {
        self.lastpageLoaded = 0;
        self.allItemsReloading = YES;
        [self requestAllPostersOnPage:(lastpageLoaded + 1)];
    }
}

@end
