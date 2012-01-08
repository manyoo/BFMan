//
//  RequestParameter.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "RequestParameter.h"
#import "NSString+Additions.h"

@implementation RequestParameter

@synthesize name;
@synthesize value;

-(id)initWithName:(NSString *)aName value:(NSString *)aValue
{
	if (self=[super init]) {
		self.name=aName;
		self.value=aValue;
	}
	return self;
}

- (NSString *)URLEncodedName 
{
	return [self.name URLEncodedString];
}

- (NSString *)URLEncodedValue 
{
    return [self.value URLEncodedString];
}

- (NSString *)URLEncodedNameValuePair 
{
    return [NSString stringWithFormat:@"%@=%@", [self URLEncodedName], [self URLEncodedValue]];
}

-(void)dealloc
{
	[name release];
	[value release];
	[super dealloc];
}

@end
