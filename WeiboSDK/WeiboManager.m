//
//  WeiboManager.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-2.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "WeiboManager.h"
#import "BlogClient.h"
#import "BFManConstants.h"

BlogClient *globalClient = nil;

@implementation WeiboManager

+(BlogClient *)getBlogClient {
    if (globalClient == nil) {
        globalClient = [[BlogClient alloc] initWithConsumerKey:SINA_WEIBO_APP_KEY_STR consumerSecret:SINA_WEIBO_APP_SECRET_STR];
    }
    return globalClient;
}

@end
