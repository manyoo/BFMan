//
//  SearchHistoryManager.m
//  SmartTao
//
//  Created by  on 12-3-11.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "SearchHistoryManager.h"

#define HISTORY_FILE @"search_history"

SearchHistoryManager *globalSearchHistoryManager = nil;

@implementation SearchHistoryManager
@synthesize historyList;

+ (SearchHistoryManager *)defaultManager {
    if (globalSearchHistoryManager == nil) {
        globalSearchHistoryManager = [[SearchHistoryManager alloc] init];
    }
    return globalSearchHistoryManager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSArray *document = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        if (document.count > 0) {
            NSURL *doc = [document objectAtIndex:0];
            NSURL *fileUrl = [NSURL URLWithString:HISTORY_FILE relativeToURL:doc];
            BOOL hasFile = [[NSFileManager defaultManager] fileExistsAtPath:[fileUrl path]];
            if (hasFile) {
                NSString *data = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:nil];
                NSArray *lines = [data componentsSeparatedByString:@"\n"];
                NSMutableArray *historys = [[NSMutableArray alloc] initWithCapacity:lines.count];
                for (NSString *line in lines) {
                    if (line != nil && ![line isEqualToString:@""]) {
                        [historys addObject:line];
                    }
                }
                self.historyList = historys;
            } else {
                self.historyList = [[NSMutableArray alloc] init];
            }
        }
    }
    return self;
}

- (NSMutableArray *)getSearchHistoryList {
    return self.historyList;
}

- (void)saveToFile {
    NSArray *document = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    if (document.count > 0) {
        NSURL *doc = [document objectAtIndex:0];
        NSURL *fileUrl = [NSURL URLWithString:HISTORY_FILE relativeToURL:doc];
        
        NSString *data = [self.historyList componentsJoinedByString:@"\n"];
        [data writeToURL:fileUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)addSearchHistory:(NSString *)str {
    NSString *histStr;
    histStr = [NSString stringWithFormat:@"%@",str];
    [historyList insertObject:histStr atIndex:0];
    [self saveToFile];
}

- (void)deleteHistoryAtIndex:(NSIndexSet *)idx {
   // [historyList removeObjectsAtIndexes:idx];
    [self saveToFile];
}

@end
