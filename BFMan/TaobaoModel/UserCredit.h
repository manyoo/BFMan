//
//  UserCredit.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCredit : NSObject

@property (nonatomic, strong) NSNumber *level;  // credit level
@property (nonatomic, strong) NSNumber *score;  // credit score
@property (nonatomic, strong) NSNumber *totalNum; // total comment numbers
@property (nonatomic, strong) NSNumber *goodNum;  // good comment numbers

+ (UserCredit *)userCreditFromResponse:(NSDictionary *)respDict;

@end
