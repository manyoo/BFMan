//
//  ShopScore.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-25.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "ShopScore.h"
#import "AppDelegate.h"

@implementation ShopScore

@dynamic itemScore;
@dynamic serviceScore;
@dynamic deliveryScore;

+ (ShopScore *)shopScoreFromDict:(NSDictionary *)dict {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    ShopScore *score = (ShopScore *)[NSEntityDescription insertNewObjectForEntityForName:@"ShopScore" inManagedObjectContext:context];
    score.itemScore = [NSNumber numberWithInt:[[dict objectForKey:@"item_score"] intValue]];
    score.serviceScore = [NSNumber numberWithInt:[[dict objectForKey:@"service_score"] intValue]];
    score.deliveryScore = [NSNumber numberWithInt:[[dict objectForKey:@"delivery_score"] intValue]];
    
    return score;
}

@end
