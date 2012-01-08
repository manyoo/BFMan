//
//  TaobaokeShop.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-25.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaobaokeShop : NSManagedObject

@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * shopTitle;
@property (nonatomic, retain) NSString * clickUrl;
@property (nonatomic, retain) NSNumber * commissionRate;
@property (nonatomic, retain) NSNumber * sellerCredit;
@property (nonatomic, retain) NSString * shopType;         // 店铺类型: B 商城  C 普通
@property (nonatomic, retain) NSNumber * totalAuction;     // 累计推广量
@property (nonatomic, retain) NSNumber * auctionCount;     // 店铺商品总数
@property (nonatomic, retain) NSManagedObject *shop;
@property (nonatomic, retain) NSNumber * position;

+ (NSArray *)fields;
+ (NSDictionary *)taobaokeShopsFromResponse:(NSDictionary *)resp;

@end
