//
//  SearchHistoryManager.h
//  SmartTao
//
//  Created by  on 12-3-11.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchHistoryManager : NSObject

@property (nonatomic, strong) NSMutableArray *historyList;

+ (SearchHistoryManager *)defaultManager;

- (NSMutableArray *)getSearchHistoryList;
- (void)addSearchHistory:(NSString *)str;
- (void)deleteHistoryAtIndex:(NSIndexSet *)idx;

@end
