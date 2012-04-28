//
//  SearchViewController.h
//  BFMan
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchListButtonView.h"
#import "SearchSwitchViewController.h"

@interface SearchViewController : UITableViewController <UISearchBarDelegate,SearchSwitchViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) SearchListButtonView *searchListButtonView;
@property (nonatomic) BOOL searchTypeHasChanged;
@property (nonatomic) SearchListType listType;
@property (nonatomic, strong) NSMutableArray *searchHistory;
@property (nonatomic, strong) NSArray *hottestSearches;

@end
