//
//  NSURL+Base.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "NSURL+Base.h"


@implementation NSURL(BaseAdditions)

-(NSString *)URLStringWithoutQuery
{
	NSArray *parts=[[self absoluteString] componentsSeparatedByString:@"?"];
	return [parts objectAtIndex:0];
}

@end
