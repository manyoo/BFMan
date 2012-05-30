//
//  Shop.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-25.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "Shop.h"
#import "ShopScore.h"

NSArray *shop_fields = nil;

@implementation Shop

@synthesize sid;
@synthesize cid;
@synthesize nick;
@synthesize title;
@synthesize desc;
@synthesize bulletin;
@synthesize picUrl;
@synthesize created;
@synthesize modified;
@synthesize shopScore;

+ (NSArray *)fields {
    if (shop_fields == nil) {
        shop_fields = [[NSArray alloc] initWithObjects:@"sid", @"cid", @"title", @"nick", @"desc", @"bulletin", @"pic_path", @"created", @"modified", @"shop_score", nil];
    }
    return shop_fields;
}

+ (Shop *)shopFromResponse:(NSDictionary *)resp {
    Shop *shop = [[Shop alloc] init];
    
    NSDictionary *shopDict = [[resp objectForKey:@"shop_get_response"] objectForKey:@"shop"];
    shop.sid = [shopDict objectForKey:@"sid"];
    shop.cid = [shopDict objectForKey:@"cid"];
    shop.nick = [shopDict objectForKey:@"nick"];
    shop.title = [shopDict objectForKey:@"title"];
    shop.desc = [shopDict objectForKey:@"desc"];
    shop.bulletin = [shopDict objectForKey:@"bulletin"];
    shop.picUrl = [NSString stringWithFormat:@"http://logo.taobao.com/shop-logo%@", [shopDict objectForKey:@"pic_path"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    shop.created = [formatter dateFromString:[shopDict objectForKey:@"created"]];
    shop.modified = [formatter dateFromString:[shopDict objectForKey:@"modified"]];
    shop.shopScore = [ShopScore shopScoreFromDict:[shopDict objectForKey:@"shop_score"]];
    
    return shop;
}

@end
