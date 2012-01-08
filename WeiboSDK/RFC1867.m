//
//  RFC1867.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-8.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "RFC1867.h"


@implementation RFC1867

@synthesize FORM_BOUNDARY;

-(id)init
{
	if (self=[super init]) {
		FORM_BOUNDARY=[[NSString alloc]initWithString: @"0194784892923"];
	}
	return self;
}

-(NSString *)nameValString:(NSDictionary *)dic
{
	NSArray *keys=[dic allKeys];
	NSString *result=[NSString string];
	for (int i=0; i<[keys count]; i++) {
		result=[result stringByAppendingString:@"--"];
		result=[result stringByAppendingString:FORM_BOUNDARY];
		result=[result stringByAppendingString:@"\r\nContent-Disposition: form-data; name=\""];
		result=[result stringByAppendingString:[keys objectAtIndex:i]];
		result=[result stringByAppendingString:@"\"\r\n\r\n"];
		result=[result stringByAppendingString:[dic valueForKey:[keys objectAtIndex:i]]];
		result=[result stringByAppendingString:@"\r\n"];
	}
	return result;
}

-(NSMutableData *)getMultipartFormData:(NSDictionary *)dic data:(NSData*)aData name:(NSString *)aName filename:(NSString *)aFilename contentType:(NSString *)aContentType
{
	NSMutableData *result=[NSMutableData data];
	NSString *param=[self nameValString:dic];
	param=[param stringByAppendingString:[NSString stringWithFormat:@"--%@\r\n",FORM_BOUNDARY]];
	param = [param stringByAppendingString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"%@\"\r\nContent-Type: %@\r\n\r\n",aName,aFilename,aContentType]];
	
	[result appendData:[param dataUsingEncoding:NSUTF8StringEncoding]];
	[result appendData:aData];
	NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", FORM_BOUNDARY];
	[result appendData:[footer dataUsingEncoding:NSUTF8StringEncoding]];
	
	return result;
}

-(void)dealloc
{
	[FORM_BOUNDARY release];
	[super dealloc];
}

@end
