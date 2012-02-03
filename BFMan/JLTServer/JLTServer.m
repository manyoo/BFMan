//
//  JLTServer.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "JLTServer.h"
#import "BFManConstants.h"
#import "ASIHTTPRequest.h"
#import "SBJsonParser.h"
#import "JLTMapper.h"
#import "NSString+MD5.h"
#import "NSString+Additions.h"

@implementation JLTServer
@synthesize delegate = _delegate, method, request = _request;

- (JLTServer *)initWithDelegate:(id<JLTServerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching binary data
    NSData *responseData = [request responseData];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *json = [parser objectWithData:responseData];
    NSInteger status = [[json objectForKey:@"status"] intValue];
    if (status) {
        id data = [json objectForKey:@"data"];
        switch (method) {
            case JLT_GETAD:
                [_delegate jltSucceedWithObject:[JLTMapper getJLTAds:data]];
                break;
            default:
                break;
        }
    } else {
        NSArray *errors = [json objectForKey:@"errors"];
        NSDictionary *error = [errors objectAtIndex:0];
        [_delegate jltErrorMessage:[error objectForKey:@"message"]];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [_delegate jltErrorMessage:@"好像服务器出问题啦，先检查一下网络，或者稍后再试试吧。:("];
}

- (void)requestForUrl:(NSString *)urlStr {
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    self.request = [[ASIHTTPRequest alloc] initWithURL:url];
    [_request setDelegate:self];
    [_request setValidatesSecureCertificate:YES];
    [_request startAsynchronous];
}

- (void)getAd {
    self.method = JLT_GETAD;
    
    NSString *urlStr = @"http://jinglingtao.com/api/get_ad";
    [self requestForUrl:urlStr];
}

- (void)dealloc {
    [self.request clearDelegatesAndCancel];
}

@end
