//
//  TaobaokeItem.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemImg;

@interface TaobaokeItem : NSObject
@property (nonatomic, strong) NSString * clickUrl;            // 推广链接
@property (nonatomic, strong) NSNumber * commission;
@property (nonatomic, strong) NSNumber * commissionNum;       // 30天总推广量
@property (nonatomic, strong) NSNumber * commissionRate;
@property (nonatomic, strong) NSNumber * commissionVolume;    // 30天总支出佣金
@property (nonatomic, strong) NSNumber * itemID;              // num_iid
@property (nonatomic, strong) NSString * itemLocation;
@property (nonatomic, strong) NSString * nick;                // seller nick
@property (nonatomic, strong) NSString * picUrl;
@property (nonatomic, strong) NSNumber * price;
@property (nonatomic, strong) NSNumber * realPrice;           // 促销价
@property (nonatomic, strong) NSNumber * sellerCreditScore;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * volume;              // 30天总交易量
@property (nonatomic, strong) NSNumber * position;

@property (nonatomic, strong) ItemImg *itemImage;

+ (NSDictionary *)taobaokeItemsFromResponse:(NSDictionary *)respDict;
+ (NSDictionary *)taobaokeItemsFromConvertResponse:(NSDictionary *)respDict;
+ (NSArray *)fields;

@end
