//
//  WeiboManager.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-2.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BlogClient;

@interface WeiboManager : NSObject

+ (BlogClient *)getBlogClient;

@end
