//
//  JLTServer.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    JLT_GETAD
} JLTAPIMethod;

@class User;
@class JLTItem;
@class ASIHTTPRequest;
@class JLTTrade;

@protocol JLTServerDelegate <NSObject>

- (void)jltSucceedWithObject:(id)obj;
- (void)jltErrorMessage:(NSString *)msg;

@end

@interface JLTServer : NSObject
@property (nonatomic, unsafe_unretained) id<JLTServerDelegate> delegate;
@property (nonatomic) JLTAPIMethod method;
@property (nonatomic, strong) ASIHTTPRequest *request;

- (JLTServer *)initWithDelegate:(id<JLTServerDelegate>)delegate;

- (void)getAd;

@end
