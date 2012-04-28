//
//  SearchSwitchViewController.h
//  SmartTao
//
//  Created by  on 12-3-10.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SS_SEARCH_ITEM,
    SS_SEARCH_SHOP
} SSSearchType;

@protocol SearchSwitchViewDelegate <NSObject>

- (void)searchTypeSelected:(SSSearchType)type;

@end

@interface SearchSwitchViewController : UITableViewController

@property (nonatomic, unsafe_unretained) id<SearchSwitchViewDelegate> delegate;

@end
