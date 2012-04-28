//
//  TBHelper.m
//  SmartTao
//
//  Created by  on 12-3-19.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "TBHelper.h"
#import "ItemWrapper.h"
#import "Item.h"
#import "TaobaokeItem.h"
#import "Shop.h"

@implementation TBHelper

@synthesize server, apiType, delegate, itemWrappers, itemIDs;

- (id)init {
    self = [super init];
    if (self) {
        self.server = [[TBServer alloc] initWithDelegate:self];
    }
    return self;
}

- (void)getTaobaokeItemsForItems:(NSArray *)itemids {
    self.itemIDs = itemids;
    self.itemWrappers = [[NSMutableDictionary alloc] initWithCapacity:itemids.count];
    for (NSNumber *itemId in itemids) {
        ItemWrapper *wrapper = [[ItemWrapper alloc] init];
        wrapper.itemId = itemId;
        [itemWrappers setValue:wrapper forKey:[NSString stringWithFormat:@"%@",itemId]];
    }
    self.apiType = TB_API_GETLISTITEM;
    [server getListItems:itemIDs];
}

#pragma mark - TBServerDelegate
- (void)requestFailed:(NSString *)msg {
    [delegate helperFailed:msg];
}

- (void)requestFinished:(id)data {
    if (apiType == TB_API_GETLISTITEM) {
        NSArray *items = (NSArray *)data;
        for (Item *item in items) {
            ItemWrapper *wrapper = [itemWrappers objectForKey:[NSString stringWithFormat:@"%@", item.itemID]];
            if (wrapper) {
                wrapper.item = item;
            }
        }
        self.apiType = TB_API_CONVERTLISTOFITEMS;
        [server convertListOfTBKItems:itemIDs];
    } else if (apiType == TB_API_CONVERTLISTOFITEMS) {
        NSDictionary *dic = (NSDictionary *)data;
        NSArray *tbkItems = [dic objectForKey:@"items"];
        for (TaobaokeItem *tbkItem in tbkItems) {
            ItemWrapper *wrapper = [itemWrappers objectForKey:[NSString stringWithFormat:@"%@",tbkItem.itemID]];
            if (wrapper) {
                wrapper.tbkItem = tbkItem;
            }
        }
        [delegate helperFinishedWith:itemWrappers];
    }
}

@end
