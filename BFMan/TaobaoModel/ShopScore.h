//
//  ShopScore.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-25.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShopScore : NSObject

@property (nonatomic, strong) NSNumber * itemScore;           // 商品描述评分
@property (nonatomic, strong) NSNumber * serviceScore;        // 服务态度评分
@property (nonatomic, strong) NSNumber * deliveryScore;       // 发货速度评分

+ (ShopScore *)shopScoreFromDict:(NSDictionary *)dict;

@end
