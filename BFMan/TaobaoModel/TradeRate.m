//
//  TradeRate.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-22.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "TradeRate.h"

@implementation TradeRate
@synthesize tid, nick, result, created, content;

+ (TradeRate *)tradeRateFromDictionary:(NSDictionary *)dict {
    TradeRate *tr = [[TradeRate alloc] init];
    
    tr.tid = [dict objectForKey:@"tid"];
    tr.nick = [dict objectForKey:@"nick"];
    
    NSString *resultStr = [dict objectForKey:@"result"];
    if ([resultStr isEqualToString:@"good"]) {
        tr.result = RATE_GOOD;
    } else if ([resultStr isEqualToString:@"neutral"]) {
        tr.result = RATE_NEUTRAL;
    } else if ([resultStr isEqualToString:@"bad"]) {
        tr.result = RATE_BAD;
    }
    
    tr.created = [dict objectForKey:@"created"];
    tr.content = [dict objectForKey:@"content"];
    
    return tr;
}

+ (NSDictionary *)tradeRatesFromResponse:(NSDictionary *)respDict {
    NSDictionary *tradeRateResp = [respDict objectForKey:@"traderates_search_response"];
    int totalResults = [[tradeRateResp objectForKey:@"total_results"] intValue];
    if (totalResults == 0) {
        return [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:totalResults] forKey:@"total_results"];
    }
    NSArray *tradeRatesArray = [[tradeRateResp objectForKey:@"trade_rates"] objectForKey:@"trade_rate"];
    
    NSMutableArray *trs = [[NSMutableArray alloc] initWithCapacity:[tradeRatesArray count]];
    for (NSDictionary *dict in tradeRatesArray) {
        [trs addObject:[TradeRate tradeRateFromDictionary:dict]];
    }
    
    NSMutableDictionary *rates = [[NSMutableDictionary alloc] initWithCapacity:2];
    [rates setValue:[NSNumber numberWithInt:totalResults] forKey:@"total_results"];
    [rates setValue:trs forKey:@"trade_rates"];
    
    return rates;
}

@end
