//
//  ClickHistoryManager.m
//  SmartTao
//
//  Created by  on 12-4-9.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "ClickHistoryManager.h"

#define CLICK_HISTORY_FILE @"click_history"
#define PAGE_SIZE 20

ClickHistoryManager *globalClickHistoryManager = nil;

@implementation ClickHistoryManager
@synthesize clickItemsList;

+ (ClickHistoryManager *)defautManager {
    if (globalClickHistoryManager == nil) {
        globalClickHistoryManager = [[ClickHistoryManager alloc] init];
    }
    return globalClickHistoryManager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSArray *document = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        if (document.count > 0) {
            NSURL *doc = [document objectAtIndex:0];
            NSURL *fileUrl = [NSURL URLWithString:CLICK_HISTORY_FILE relativeToURL:doc];
            BOOL hasFile = [[NSFileManager defaultManager] fileExistsAtPath:[fileUrl path]];
            if (hasFile) {
                NSString *data = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:nil];
                NSArray *lines = [data componentsSeparatedByString:@"\n"];
                NSMutableArray *historys = [[NSMutableArray alloc] initWithCapacity:lines.count];
                for (NSString *line in lines) {
                    if (line != nil && ![line isEqualToString:@""]) {
                        [historys addObject:[NSNumber numberWithLongLong:[line longLongValue]]];
                    }
                }
                self.clickItemsList = historys;
            } else {
                self.clickItemsList = [[NSMutableArray alloc] init];
            }
        }
    }
    return self;
}

- (void)saveToFile {
    NSArray *document = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    if (document.count > 0) {
        NSURL *doc = [document objectAtIndex:0];
        NSURL *fileUrl = [NSURL URLWithString:CLICK_HISTORY_FILE relativeToURL:doc];
        
        NSString *data = [clickItemsList componentsJoinedByString:@"\n"];
        [data writeToURL:fileUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (NSArray *)getClickHistoryAtPage:(NSInteger)page {
    int count = clickItemsList.count;
    int left = count - page * PAGE_SIZE;
    NSRange range;
    if (left <= 0) {
        return nil;
    } else if (left < PAGE_SIZE) {
        range = NSMakeRange(page * PAGE_SIZE, left);
    } else {
        range = NSMakeRange(page * PAGE_SIZE, PAGE_SIZE);
    }
    return [clickItemsList subarrayWithRange:range];
}

- (void)addClickItem:(NSNumber *)itemId {
    int idx = -1;
    for (int i = 0; i < clickItemsList.count; ++i) {
        if ([[clickItemsList objectAtIndex:i] isEqualToNumber:itemId]) {
            idx = i;
            break;
        }
    }
    if (idx >= 0) {
        [clickItemsList removeObjectAtIndex:idx];
    }
    
    [clickItemsList insertObject:itemId atIndex:0];
    
    if (clickItemsList.count > 200) {
        [clickItemsList removeLastObject];
    }
    [self saveToFile];
}

- (BOOL)hasItem:(NSNumber *)itemId {
    for (NSNumber *tid in clickItemsList) {
        if ([tid isEqualToNumber:itemId]) {
            return YES;
        }
    }
    return NO;
}

- (void)clearAllHistory {
    self.clickItemsList = [[NSMutableArray alloc] init];
    [self saveToFile];
}

@end
