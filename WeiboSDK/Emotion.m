//
//  Emotion.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-24.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "Emotion.h"


@implementation Emotion
@synthesize phrase;
@synthesize type;
@synthesize url;
@synthesize is_hot;
@synthesize order_number;
@synthesize category;

-(id)initWithJson:(NSDictionary*)dic
{
	if (self=[super init]) {
		
		self.phrase=[dic getStringValueForKey:@"phrase" defaultValue:@""];
		self.type=[dic getStringValueForKey:@"type" defaultValue:@""];
		self.url=[dic getStringValueForKey:@"url" defaultValue:@""];
		
	
		self.is_hot=[dic getBoolValueForKey:@"is_hot" defaultValue:NO];
		self.order_number=[dic getIntValueForKey:@"order_number" defaultValue:0];
		self.category=[dic getStringValueForKey:@"category" defaultValue:@""];
	}
	
	return self;
}


-(void)dealloc
{
	[phrase release];
	[type release];
	[url release];
	[category release];
	[super dealloc];
}

@end
