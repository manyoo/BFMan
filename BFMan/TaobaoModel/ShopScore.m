//
//  ShopScore.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-25.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "ShopScore.h"

@implementation ShopScore

@synthesize itemScore;
@synthesize serviceScore;
@synthesize deliveryScore;

+ (ShopScore *)shopScoreFromDict:(NSDictionary *)dict {
    ShopScore *score = [[ShopScore alloc] init];
    score.itemScore = [NSNumber numberWithInt:[[dict objectForKey:@"item_score"] intValue]];
    score.serviceScore = [NSNumber numberWithInt:[[dict objectForKey:@"service_score"] intValue]];
    score.deliveryScore = [NSNumber numberWithInt:[[dict objectForKey:@"delivery_score"] intValue]];
    
    return score;
}

@end
