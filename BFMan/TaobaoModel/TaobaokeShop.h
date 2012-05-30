//
//  TaobaokeShop.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-25.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaobaokeShop : NSObject

@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSString * shopTitle;
@property (nonatomic, strong) NSString * clickUrl;
@property (nonatomic, strong) NSNumber * commissionRate;
@property (nonatomic, strong) NSNumber * sellerCredit;
@property (nonatomic, strong) NSString * shopType;         // 店铺类型: B 商城  C 普通
@property (nonatomic, strong) NSNumber * totalAuction;     // 累计推广量
@property (nonatomic, strong) NSNumber * auctionCount;     // 店铺商品总数
@property (nonatomic, strong) NSManagedObject *shop;
@property (nonatomic, strong) NSNumber * position;

+ (NSArray *)fields;
+ (NSDictionary *)taobaokeShopsFromResponse:(NSDictionary *)resp;

@end
