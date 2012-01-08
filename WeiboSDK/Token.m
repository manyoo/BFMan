//
//  Token.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "Token.h"


@implementation Token

@synthesize key,secret,pin;

-(id)init
{
	if (self=[super init]) {
		self.key=@"";
		self.secret=@"";
	}
	return self;
}

- (id)initWithHTTPResponseBody:(NSString *)body
{
	if (self=[super init]) {
		NSArray *pairs=[body componentsSeparatedByString:@"&"];
		for (NSString *pair in pairs) {
			NSArray *elements=[pair componentsSeparatedByString:@"="];
			if ([[elements objectAtIndex:0] isEqualToString:@"oauth_token"]) {
				self.key=[[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			}else if ([[elements objectAtIndex:0] isEqualToString:@"oauth_token_secret"]) {
				self.secret=[[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			}else if ([[elements objectAtIndex:0] isEqualToString:@"oauth_verifier"]) {
				self.pin = [elements objectAtIndex:1];
			}
		}
	}
	return self;
}

@end
