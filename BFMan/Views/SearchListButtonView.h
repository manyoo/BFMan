//
//  SearchListButtonView.h
//  SmartTao
//
//  Created by  on 12-3-11.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchButton;

typedef enum {
    SL_HISTORY,
    SL_HOT
} SearchListType;

@protocol SearchListButtonViewDelegate <NSObject>

- (void)listTypeSelected:(SearchListType)type;

@end

@interface SearchListButtonView : UIView

@property (nonatomic) SearchListType currentListType;
@property (nonatomic, strong) SearchButton *searchHistoryButton;
@property (nonatomic, strong) SearchButton *searchHotButton;
@property (nonatomic, unsafe_unretained) id<SearchListButtonViewDelegate> delegate;

@end
