//
//  TaobaokeShop.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-25.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "TaobaokeShop.h"
#import "AppDelegate.h"
#import "NSString+HTML.h"

NSArray *taobaoke_shop_fields = nil;

@implementation TaobaokeShop

@dynamic userId;
@dynamic shopTitle;
@dynamic clickUrl;
@dynamic commissionRate;
@dynamic sellerCredit;
@dynamic shopType;
@dynamic totalAuction;
@dynamic auctionCount;
@dynamic shop;
@dynamic position;

+ (NSArray *)fields {
    if (taobaoke_shop_fields == nil) {
        taobaoke_shop_fields = [[NSArray alloc] initWithObjects:@"user_id", @"shop_title", @"click_url", @"commission_rate", @"seller_credit", @"shop_type", @"total_auction", @"auction_count", nil];
    }
    return taobaoke_shop_fields;
}

+ (TaobaokeShop *)taobaokeShopFromResponse:(NSDictionary *)resp {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    TaobaokeShop *shop = [NSEntityDescription insertNewObjectForEntityForName:@"TaobaokeShop" inManagedObjectContext:context];
    shop.userId = [resp objectForKey:@"user_id"];
    shop.shopTitle = [[resp objectForKey:@"shop_title"] stringByDecodingHTMLEntities];
    shop.clickUrl = [resp objectForKey:@"click_url"];
    shop.commissionRate = [NSNumber numberWithFloat:[[resp objectForKey:@"commission_rate"] floatValue]];
    shop.sellerCredit = [NSNumber numberWithInt:[[resp objectForKey:@"seller_credit"] intValue]];
    shop.shopType = [resp objectForKey:@"shop_type"];
    shop.totalAuction = [NSNumber numberWithInt:[[resp objectForKey:@"total_auction"] intValue]];
    shop.auctionCount = [NSNumber numberWithInt:[[resp objectForKey:@"auction_count"] intValue]];
    
    return shop;
}

+ (NSDictionary *)taobaokeShopsFromResponse:(NSDictionary *)resp {
    NSDictionary *getResp = [resp objectForKey:@"taobaoke_shops_get_response"];
    int totalResults = [[getResp objectForKey:@"total_results"] intValue];
    if ([getResp count] == 0) {
        return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"total_results"];
    }
    NSArray *shopDicts = [[getResp objectForKey:@"taobaoke_shops"] objectForKey:@"taobaoke_shop"];
    NSMutableArray *shops = [[NSMutableArray alloc] initWithCapacity:[shopDicts count]];
    for (NSDictionary *d in shopDicts) {
        [shops addObject:[TaobaokeShop taobaokeShopFromResponse:d]];
    }
    
    NSMutableDictionary *res = [[NSMutableDictionary alloc] initWithCapacity:2];
    [res setValue:[NSNumber numberWithInt:totalResults] forKey:@"total_results"];
    [res setValue:shops forKey:@"shops"];
    return res;
}

@end
