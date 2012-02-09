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
    NSURL *u = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://bai.lu/api?url=%@",[url URLEncodedString]]];
    self.request = [[ASIHTTPRequest alloc] initWithURL:u];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [delegate shortUrlFailed:@""];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *json = [parser objectWithData:request.responseData];
    if ([[json objectForKey:@"status"] isEqualToString:@"ok"]) {
        [delegate shortUrlFinished:[json objectForKey:@"url"]];
    } else
        [delegate shortUrlFailed:@""];
}

- (void)dealloc {
    [request clearDelegatesAndCancel];
}

@end
