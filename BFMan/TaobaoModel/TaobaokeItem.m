//
//  TaobaokeItem.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "TaobaokeItem.h"
#import "NSString+HTML.h"

NSArray *taobaoke_item_fields = nil;

@implementation TaobaokeItem
@synthesize commissionRate, itemID, title, nick, picUrl, price, clickUrl,
commission, commissionNum, commissionVolume, sellerCreditScore, itemLocation, volume, itemImage, realPrice, position;

+ (NSArray *)fields {
    if (taobaoke_item_fields == nil) {
        taobaoke_item_fields = [[NSArray alloc] initWithObjects:@"commission_rate", @"num_iid", @"title", @"nick", @"pic_url", 
                                @"price", @"click_url", @"commission", @"commission_num", @"commission_volume",
                                @"seller_credit_score", @"item_location", @"volume", nil];
    }
    return taobaoke_item_fields;
}

+ (TaobaokeItem *)taobaokeItemFromDictionary:(NSDictionary *)dict {    
    TaobaokeItem *item = [[TaobaokeItem alloc] init];
    
    item.commissionRate = [NSNumber numberWithFloat:([[dict objectForKey:@"commission_rate"] floatValue] / 10000)];
    item.itemID = [dict objectForKey:@"num_iid"];
    item.title = [[dict objectForKey:@"title"] stringByDecodingHTMLEntities];
    item.nick = [dict objectForKey:@"nick"];
    item.picUrl = [dict objectForKey:@"pic_url"];
    item.price = [NSNumber numberWithFloat:[[dict objectForKey:@"price"] floatValue]];
    item.clickUrl = [dict objectForKey:@"click_url"];
    item.commission = [NSNumber numberWithFloat:[[dict objectForKey:@"commission"] floatValue]];
    item.commissionNum = [NSNumber numberWithFloat:[[dict objectForKey:@"commission_num"] floatValue]];
    item.commissionVolume = [NSNumber numberWithFloat:[[dict objectForKey:@"commission_volume"] floatValue]];
    item.sellerCreditScore = [dict objectForKey:@"seller_credit_score"];
    item.itemLocation = [dict objectForKey:@"item_location"];
    item.volume = [dict objectForKey:@"volume"];
    item.realPrice = [NSNumber numberWithFloat:0];
    
    return item;
}

+ (NSDictionary *)taobaokeItemsFromResponse:(NSDictionary *)respDict {
    NSDictionary *itemsResp = [respDict objectForKey:@"taobaoke_items_get_response"];
    int total_results = [[itemsResp objectForKey:@"total_results"] intValue];
    if ([itemsResp count] == 0) {
        return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:total_results] forKey:@"total_results"];
    }
    
    NSDictionary *itemsDict = [itemsResp objectForKey:@"taobaoke_items"];
    NSArray *itemsArray = [itemsDict objectForKey:@"taobaoke_item"];
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[itemsArray count]];
    for (NSDictionary *dict in itemsArray) {
        [items addObject:[TaobaokeItem taobaokeItemFromDictionary:dict]];
    }
    
    NSMutableDictionary *itemsResult = [[NSMutableDictionary alloc] initWithCapacity:2];
    [itemsResult setValue:[NSNumber numberWithInt:total_results] forKey:@"total_results"];
    [itemsResult setValue:items forKey:@"items"];
    return itemsResult;
}

+ (NSDictionary *)taobaokeItemsFromConvertResponse:(NSDictionary *)respDict {
    NSDictionary *itemsResp = [respDict objectForKey:@"taobaoke_items_convert_response"];
    int total_results = [[itemsResp objectForKey:@"total_results"] intValue];
    if ([itemsResp count] == 0) {
        return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:total_results] forKey:@"total_results"];
    }
    
    NSDictionary *itemsDict = [itemsResp objectForKey:@"taobaoke_items"];
    NSArray *itemsArray = [itemsDict objectForKey:@"taobaoke_item"];
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[itemsArray count]];
    for (NSDictionary *dict in itemsArray) {
        [items addObject:[TaobaokeItem taobaokeItemFromDictionary:dict]];
    }
    
    NSMutableDictionary *itemsResult = [[NSMutableDictionary alloc] initWithCapacity:2];
    [itemsResult setValue:[NSNumber numberWithInt:total_results] forKey:@"total_results"];
    [itemsResult setValue:items forKey:@"items"];
    return itemsResult;
}

@end
