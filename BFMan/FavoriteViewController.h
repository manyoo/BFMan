//
//  FavoriteViewController.h
//  BFMan
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBHelper.h"
#import "LoadingTableViewCell.h"

typedef enum {
    CELL_DATA,
    CELL_MORE
} CellType;

@interface FavoriteViewController : UITableViewController <TBHelperDelegate>

@property (nonatomic, strong) TBHelper *helper;
@property (nonatomic) NSInteger lastpageLoaded;
@property (nonatomic, strong) NSMutableArray *itemIds;
@property (nonatomic, strong) NSArray *itemIdsLastPage;
@property (nonatomic, strong) NSMutableArray *cellTypes;
@property (nonatomic, strong) NSMutableDictionary *itemWrappers;

@property (nonatomic) BOOL needToScroll;
@property (nonatomic) NSInteger indexOpened;

@property (nonatomic, strong) LoadingTableViewCell *loadingCell;

@end
