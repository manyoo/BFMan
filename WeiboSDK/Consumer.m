//
//  Consumer.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "Consumer.h"


@implementation Consumer
@synthesize key,secret;

-(id)initWithKey:(NSString *)aKey secret:(NSString *)aSecret
{
	if (self=[super init]) {
		self.key=aKey;
		self.secret=aSecret;
	}
	return self;
}

-(void)dealloc
{
	[key release];
	[secret release];
	[super dealloc];
}

@end
