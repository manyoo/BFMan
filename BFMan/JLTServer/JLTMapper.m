//
//  JLTMapper.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-19.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "JLTMapper.h"
#import "JLTAd.h"

@implementation JLTMapper

+ (JLTAd *)getJLTAd:(NSDictionary *)dict {
    JLTAd *ad = [[JLTAd alloc] init];
    
    ad.adPicUrl = [dict objectForKey:@"ad_pic_url"];
    ad.adUrl = [dict objectForKey:@"ad_url"];
    
    return ad;
}

+ (NSMutableArray *)getJLTAds:(NSArray *)arr {
    NSMutableArray *ads = [[NSMutableArray alloc] initWithCapacity:[arr count]];
    
    for (NSDictionary *dict in arr) {
        [ads addObject:[JLTMapper getJLTAd:dict]];
    }
    
    return ads;
}

@end
