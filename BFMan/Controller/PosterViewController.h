//
//  PosterViewController.h
//  BFMan
//
//  Created by  on 12-1-22.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

typedef enum {
    CELL_RELOAD,
    CELL_DATA
} CellType;

@class LoadingTableViewCell;

@interface PosterViewController : UITableViewController <EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) LoadingTableViewCell *loadingCell;
@property (nonatomic, strong) NSMutableArray *posters;
@property (nonatomic, strong) NSMutableArray *cellTypes;
@property (nonatomic) NSInteger lastpageLoaded;
@property (nonatomic) BOOL reloading;
@property (nonatomic) BOOL allItemsReloading;
@property (nonatomic) BOOL refreshEnabled;
@property (nonatomic) BOOL multipageEnabled;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)loadMoreData;

@end
