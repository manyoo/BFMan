//
//  CollectItem.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-26.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "CollectItem.h"
#import "NSString+HTML.h"

@implementation CollectItem

@synthesize itemOwnerNick, itemNumId, title, tbkItem;

+ (CollectItem *)collectItemFromDictionary:(NSDictionary *)dict {
    CollectItem *item = [[CollectItem alloc] init];
    
    item.itemOwnerNick = [dict objectForKey:@"item_owner_nick"];
    item.itemNumId = [dict objectForKey:@"item_numid"];
    item.title = [[dict objectForKey:@"title"] stringByDecodingHTMLEntities];
    item.tbkItem = nil;
    
    return item;
}

+ (NSDictionary *)collectItemsFromResponse:(NSDictionary *)resp {
    NSDictionary *fav = [resp objectForKey:@"favorite_search_response"];
    int totalResult = [[fav objectForKey:@"total_results"] intValue];
    if (totalResult == 0) {
        return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"total_results"];
    }
    
    NSArray *itemsArr = [[fav objectForKey:@"collect_items"] objectForKey:@"collect_item"];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[itemsArr count]];
    
    for (NSDictionary *dict in itemsArr) {
        [items addObject:[CollectItem collectItemFromDictionary:dict]];
    }
    NSMutableDictionary *res = [[NSMutableDictionary alloc] initWithCapacity:2];
    [res setValue:[NSNumber numberWithInt:totalResult] forKey:@"total_results"];
    [res setValue:items forKey:@"items"];
    
    return res;
}

@end
