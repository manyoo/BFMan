//
//  UserCredit.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "UserCredit.h"

@implementation UserCredit
@synthesize level, score, totalNum, goodNum;

+ (UserCredit *)userCreditFromResponse:(NSDictionary *)respDict {
    UserCredit *credit = [[UserCredit alloc] init];
    
    credit.level = [respDict objectForKey:@"level"];
    credit.score = [respDict objectForKey:@"score"];
    credit.totalNum = [respDict objectForKey:@"total_num"];
    credit.goodNum = [respDict objectForKey:@"good_num"];
    
    return credit;
}

@end
