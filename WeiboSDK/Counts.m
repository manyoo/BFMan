//
//  Counts.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-22.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "Counts.h"


@implementation Counts
@synthesize statusId;
@synthesize comments;
@synthesize rt;

-(Counts *)initWithJson:(NSDictionary*)dic
{
	if (self=[super init]) {
		
		statusId=[dic getLongLongValueForKey:@"id" defaultValue:-1];
		comments=[dic getLongLongValueForKey:@"comments" defaultValue:-1];
		rt=[dic getLongLongValueForKey:@"rt" defaultValue:-1];
	}
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end
