//
//  ImageMemCache.h
//  SmartTao
//
//  Created by  on 12-5-14.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageMemCache : NSObject

@property (nonatomic, strong) NSMutableDictionary *images;

+ (ImageMemCache *)sharedImageMemCache;

- (void)addImage:(UIImage *)img forKey:(NSString *)key;
- (UIImage *)getImageForKey:(NSString *)key;
- (void)clearCache;

@end
