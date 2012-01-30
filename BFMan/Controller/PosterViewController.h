//
//  PosterViewController.h
//  BFMan
//
//  Created by  on 12-1-22.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "TBServer.h"

typedef enum {
    CELL_RELOAD,
    CELL_DATA
} CellType;

typedef enum {
    API_GETPICTURE,
    API_GETAUCTION,
    API_GETHOT,
    API_GETRECOMMEND,
    API_GETALL
} APIType;

@class LoadingTableViewCell;
@class HuaBao;

@interface PosterViewController : UITableViewController <EGORefreshTableHeaderDelegate,TBServerDelegate>

@property (nonatomic, strong) TBServer *server;
@property (nonatomic) APIType apiType;
@property (nonatomic, strong) NSArray *huabaoPictures;
@property (nonatomic, strong) NSArray *huabaoAuctions;
@property (nonatomic, strong) HuaBao *selectedHuaBao;

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
