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

@interface TaobaokeItem : NSManagedObject
@property (nonatomic, retain) NSString * clickUrl;            // 推广链接
@property (nonatomic, retain) NSNumber * commission;
@property (nonatomic, retain) NSNumber * commissionNum;       // 30天总推广量
@property (nonatomic, retain) NSNumber * commissionRate;
@property (nonatomic, retain) NSNumber * commissionVolume;    // 30天总支出佣金
@property (nonatomic, retain) NSNumber * itemID;              // num_iid
@property (nonatomic, retain) NSString * itemLocation;
@property (nonatomic, retain) NSString * nick;                // seller nick
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * realPrice;           // 促销价
@property (nonatomic, retain) NSNumber * sellerCreditScore;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * volume;              // 30天总交易量
@property (nonatomic, retain) NSNumber * position;

@property (nonatomic, retain) ItemImg *itemImage;

+ (NSDictionary *)taobaokeItemsFromResponse:(NSDictionary *)respDict;
+ (NSDictionary *)taobaokeItemsFromConvertResponse:(NSDictionary *)respDict;
+ (NSArray *)fields;

@end
