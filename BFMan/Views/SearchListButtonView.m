//
//  SearchListButtonView.m
//  SmartTao
//
//  Created by  on 12-3-11.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "SearchListButtonView.h"
#import "SearchButton.h"


@implementation SearchListButtonView
@synthesize currentListType, searchHistoryButton, searchHotButton, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.currentListType = SL_HISTORY;
        
        CGFloat width = frame.size.width / 2, height = frame.size.height;
        self.searchHistoryButton = [SearchButton buttonWithType:UIButtonTypeCustom];
        searchHistoryButton.frame = CGRectMake(0, 0.5, width, height - 1.5);
        [searchHistoryButton setTitle:@"搜索历史" forState:UIControlStateNormal];
        [searchHistoryButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [searchHistoryButton changeButton];
        
        [self addSubview:searchHistoryButton];
        
        self.searchHotButton = [SearchButton buttonWithType:UIButtonTypeCustom];
        searchHotButton.frame = CGRectMake(width, 0.5, width, height - 1.5);
        [searchHotButton setTitle:@"搜索热词" forState:UIControlStateNormal];
        [searchHotButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [searchHotButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:searchHotButton];
        
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)buttonPressed:(id)sender {
    SearchButton *button = (SearchButton *)sender;
    
    if (button == searchHistoryButton) {
        if (currentListType == SL_HOT) {
            [searchHistoryButton changeButton];
            [searchHotButton changeButton];
            self.currentListType = SL_HISTORY;
            [delegate listTypeSelected:currentListType];
        }
    } else if (button == searchHotButton) {
        if (currentListType == SL_HISTORY) {
            [searchHistoryButton changeButton];
            [searchHotButton changeButton];
            self.currentListType = SL_HOT;
            [delegate listTypeSelected:currentListType];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
