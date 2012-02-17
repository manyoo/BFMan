//
//  BailuServer.m
//  SmartTao
//
//  Created by  on 12-2-8.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "BailuServer.h"
#import "NSString+Additions.h"
#import "SBJsonParser.h"

@implementation BailuServer
@synthesize request, delegate;

- (void)getShortUrlFor:(NSString *)url {
    NSURL *u = [[NSURL alloc] initWithString:@"http://dwz.cn/create.php"];
    self.request = [[ASIFormDataRequest alloc] initWithURL:u];
    request.requestMethod = @"POST";
    [request setPostValue:url forKey:@"url"];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestFailed:(ASIFormDataRequest *)request {
    [delegate shortUrlFailed:@""];
}

- (void)requestFinished:(ASIFormDataRequest *)request {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *json = [parser objectWithData:request.responseData];
    if ([[json objectForKey:@"status"] intValue] == 0) {
        [delegate shortUrlFinished:[json objectForKey:@"tinyurl"]];
    } else
        [delegate shortUrlFailed:@""];
}

- (void)dealloc {
    [request clearDelegatesAndCancel];
}

@end
