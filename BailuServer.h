//
//  BailuServer.h
//  SmartTao
//
//  Created by  on 12-2-8.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol BailuServerDelegate <NSObject>

- (void)shortUrlFinished:(NSString *)shortUrl;
- (void)shortUrlFailed:(NSString *)msg;

@end

@interface BailuServer : NSObject

@property (nonatomic, strong) ASIHTTPRequest *request;
@property (nonatomic, unsafe_unretained) id<BailuServerDelegate> delegate;

- (void)getShortUrlFor:(NSString *)url;

@end
