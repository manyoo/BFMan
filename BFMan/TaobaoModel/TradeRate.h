//
//  TradeRate.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-22.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RATE_GOOD,
    RATE_NEUTRAL,
    RATE_BAD
} RateType;

@interface TradeRate : NSObject

@property (nonatomic, strong) NSNumber *tid;        // trade id
@property (nonatomic, strong) NSString *nick;       // 评价者昵称
@property (nonatomic) RateType result;              // 评价结果
@property (nonatomic, strong) NSString *created;
@property (nonatomic, strong) NSString *content;

+ (NSDictionary *)tradeRatesFromResponse:(NSDictionary *)respDict;

@end
