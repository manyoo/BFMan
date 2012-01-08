//
//  OAMutableURLRequest.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "OAMutableURLRequest.h"

@interface OAMutableURLRequest(Private)

-(void)_generateTimestamp;
-(void)_generateNonce;
-(NSString *)_signatureBaseString;

@end


@implementation OAMutableURLRequest

-(id)initWithURL:(NSURL *)aURL consumer:(Consumer *)aConsumer token:(Token *)aToken
{
	if (self=[super initWithURL:aURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0]) {
		consumer=[aConsumer retain];
		if (aToken==nil) {
			token=[[Token alloc] init];
		}else {
			token=[aToken retain];
		}

		realm=[[NSString alloc]initWithString:@""];
		signatureProvider=[[HMAC_SHA1SignatureProvider alloc] init];
		[self _generateTimestamp];
		[self _generateNonce];
	}
	
	return self;
}

- (void)prepare
{
	NSString *signClearText = [self _signatureBaseString];
	NSString *secret = [NSString stringWithFormat:@"%@&%@",[consumer.secret URLEncodedString],[token.secret URLEncodedString]];
	//NSLog(@"secret:%@",secret);
	
    signature = [signatureProvider signClearText:signClearText secret:secret];
    
    NSString *oauthToken;
    if ([token.key isEqualToString:@""])
	{
        oauthToken = @""; 
	}
    else
	{
        oauthToken = [NSString stringWithFormat:@"oauth_token=\"%@\", ", [token.key URLEncodedString]];
	}
	
	NSMutableString *extraParameters = [NSMutableString string];
	
	for(NSString *parameterName in [[extraOAuthParameters allKeys] sortedArrayUsingSelector:@selector(compare:)])
	{
		[extraParameters appendFormat:@", %@=\"%@\"",[parameterName URLEncodedString],[[extraOAuthParameters objectForKey:parameterName] URLEncodedString]];
	}	
    
    NSString *oauthHeader = [NSString stringWithFormat:@"OAuth realm=\"%@\", oauth_consumer_key=\"%@\", %@oauth_signature_method=\"%@\", oauth_signature=\"%@\", oauth_timestamp=\"%@\", oauth_nonce=\"%@\", oauth_version=\"1.0\"%@",
                             [realm URLEncodedString],
                             [consumer.key URLEncodedString],
                             oauthToken,
                             [[signatureProvider name] URLEncodedString],
                             [signature URLEncodedString],
                             timestamp,
                             nonce,
							 extraParameters];
	
	if (token.pin.length)
	{
		oauthHeader = [oauthHeader stringByAppendingFormat: @", oauth_verifier=\"%@\"", token.pin];
	}
    //NSLog(@"oauthHeader:%@", oauthHeader);
	[self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
}

-(void)_generateTimestamp
{
	timestamp=[[NSString stringWithFormat:@"%d",time(NULL)] retain];
}

-(void)_generateNonce
{
	CFUUIDRef theUUID=CFUUIDCreate(NULL);
	CFStringRef string=CFUUIDCreateString(NULL, theUUID);
	//回收
	[NSMakeCollectable(theUUID) release];
	nonce=(NSString *)string;
}

-(NSString *)_signatureBaseString
{
	NSArray *parameters = [self parameters];
    NSMutableArray *parameterPairs = [NSMutableArray  arrayWithCapacity:(6 + [parameters count])]; 

	RequestParameter *p1=[[RequestParameter alloc] initWithName:@"oauth_consumer_key" value:consumer.key];
	[parameterPairs addObject:[p1 URLEncodedNameValuePair]];
	[p1 release];

	RequestParameter *p2=[[RequestParameter alloc] initWithName:@"oauth_signature_method" value:[signatureProvider name]];
	[parameterPairs addObject:[p2 URLEncodedNameValuePair]];
	[p2 release];

	RequestParameter *p3=[[RequestParameter alloc] initWithName:@"oauth_timestamp" value:timestamp];
	[parameterPairs addObject:[p3 URLEncodedNameValuePair]];
	[p3 release];

	RequestParameter *p4=[[RequestParameter alloc] initWithName:@"oauth_nonce" value:nonce];
	[parameterPairs addObject:[p4 URLEncodedNameValuePair]];
	[p4 release];

	RequestParameter *p5=[[RequestParameter alloc] initWithName:@"oauth_version" value:@"1.0"];
	[parameterPairs addObject:[p5 URLEncodedNameValuePair]];
	[p5 release];
  
    if (![token.key isEqualToString:@""]) {
		RequestParameter *p6=[[RequestParameter alloc] initWithName:@"oauth_token" value:token.key];
		[parameterPairs addObject:[p6 URLEncodedNameValuePair]];
		[p6 release];
    }
	if (token.pin.length > 0) {
		RequestParameter *p7=[[RequestParameter alloc] initWithName:@"oauth_verifier" value:token.pin];
		[parameterPairs addObject:[p7 URLEncodedNameValuePair]];
		[p7 release];
	}	
    for (RequestParameter *param in parameters) {
        [parameterPairs addObject:[param URLEncodedNameValuePair]];
    }
    
    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];

    NSString *ret = [NSString stringWithFormat:@"%@&%@&%@",
					 [self HTTPMethod],
					 [[[self URL] URLStringWithoutQuery] URLEncodedString],
					 [normalizedRequestParameters URLEncodedString]];
	
    //NSLog(@"normalizedRequestParameters: %@, ret: %@",normalizedRequestParameters, ret);
	return ret;
}

-(void)dealloc
{
	[consumer release];
	[token release];
	[signatureProvider release];
	[nonce release];
	[timestamp release];
	[realm release];
	[extraOAuthParameters release];
	[super dealloc];
}

@end
