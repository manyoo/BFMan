//
//  HomeViewController.h
//  BFMan
//
//  Created by  on 12-5-28.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBServer.h"
#import "ChannelSelectioniPadViewController.h"
#import "EGORefreshTableHeaderView.h"

typedef enum {
    HOT_POSTERS,
    ALL_POSTERS,
    SEARCH_RESULTS 
} PosterListType;

typedef enum {
    API_GETPICTURE,
    API_GETAUCTION,
    API_GETHOT,
    API_GETRECOMMEND,
    API_GETALL,
    API_SEARCH
} APIType;

@class LoadingTableViewCell;
@class HuaBao;
@class MoreInfoViewController;

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, TBServerDelegate, ChannelSelectioniPadViewControllerDelegate, EGORefreshTableHeaderDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) TBServer *server;
@property (nonatomic) APIType apiType;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic) PosterListType listType;

@property (nonatomic, strong) NSMutableArray *posters;
@property (nonatomic, strong) NSMutableArray *hotPosters;
@property (nonatomic, strong) NSMutableArray *allPosters;
@property (nonatomic, strong) NSNumber *currentChannelId;

@property (nonatomic) BOOL hasMoreData;

@property (nonatomic, strong) NSArray *huabaoPictures;
@property (nonatomic, strong) HuaBao *selectedHuaBao;

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) LoadingTableViewCell *loadingCell;
@property (nonatomic) NSInteger lastpageLoaded;
@property (nonatomic) BOOL reloading;
@property (nonatomic) BOOL allItemsReloading;
@property (nonatomic) BOOL refreshEnabled;
@property (nonatomic) BOOL multipageEnabled;
@property (nonatomic) BOOL needToScroll;
@property (nonatomic) NSInteger indexOpened;
@property (nonatomic, strong) ChannelSelectioniPadViewController *channelSelectionViewController;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *channelButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;

@property (nonatomic, strong) UIPopoverController *settingsPopoverController;
@property (nonatomic, strong) MoreInfoViewController *moreInfoViewController;

@property (nonatomic, strong) NSString *searchKeyword;

- (IBAction)changeType:(id)sender;
- (IBAction)channelButtonClicked:(id)sender;
- (IBAction)settings:(id)sender;

@end
