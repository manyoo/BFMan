//
//  ClickHistoryManager.h
//  SmartTao
//
//  Created by  on 12-4-9.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClickHistoryManager : NSObject

@property (nonatomic, strong) NSMutableArray *clickItemsList;

+ (ClickHistoryManager *)defautManager;

- (NSArray *)getClickHistoryAtPage:(NSInteger)page;
- (void)addClickItem:(NSNumber *)itemId;
- (BOOL)hasItem:(NSNumber *)itemId;
- (void)deleteHistoryAtIndex:(NSInteger)idx;
- (void)clearAllHistory;

@end
