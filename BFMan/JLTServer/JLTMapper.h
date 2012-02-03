//
//  JLTMapper.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-19.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JLTAd;

@interface JLTMapper : NSObject

+ (JLTAd *)getJLTAd:(NSDictionary *)dict;

+ (NSMutableArray *)getJLTAds:(NSArray *)arr;

@end
