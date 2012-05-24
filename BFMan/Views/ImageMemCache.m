//
//  ImageMemCache.m
//  SmartTao
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "ImageMemCache.h"

ImageMemCache *globalCache = nil;

@implementation ImageMemCache
@synthesize images;

- (id)init {
    self = [super init];
    if (self) {
        self.images = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (ImageMemCache *)sharedImageMemCache {
    if (globalCache == nil) {
        globalCache = [[ImageMemCache alloc] init];
    }
    return globalCache;
}

- (void)addImage:(UIImage *)img forKey:(NSString *)key {
    [images setValue:img forKey:key];
}

- (UIImage *)getImageForKey:(NSString *)key {
    return [images objectForKey:key];
}

- (void)clearCache {
    if ([images count] > 0) {
        self.images = [[NSMutableDictionary alloc] init];
    }
}

@end
