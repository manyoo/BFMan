//
//  OAMutableURLRequest.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Consumer.h"
#import "Token.h"
#import "HMAC_SHA1SignatureProvider.h"
#import "NSMutableURLRequest+Parameters.h"
#import "NSString+Additions.h"

@interface OAMutableURLRequest : NSMutableURLRequest {
	Consumer *consumer;
	Token *token;
	id<SignatureProtocol> signatureProvider;
	NSString *nonce;
	NSString *timestamp;
	NSString *realm;
	
	NSString *signature;
	NSMutableDictionary *extraOAuthParameters;
}

-(id)initWithURL:(NSURL *)aURL consumer:(Consumer *)aConsumer token:(Token *)aToken;
- (void)prepare;

@end
