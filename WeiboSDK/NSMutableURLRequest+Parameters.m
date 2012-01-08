//
//  NSMutableURLRequest+Parameters.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "NSMutableURLRequest+Parameters.h"


@implementation NSMutableURLRequest(ParameterAdditions)

-(NSArray *)parameters
{
	NSString *encodeParameters;
	BOOL shouldfree=NO;
	
	NSString *contentType=[self valueForHTTPHeaderField:@"Content-Type"];
	if ([contentType hasPrefix:@"multipart/form-data; boundary="]) {
		encodeParameters=[[self URL] query];
		
		NSString *absoluteString=[self.URL absoluteString];
		NSRange rang=[absoluteString rangeOfString:@"?"];
		if (rang.location!=NSNotFound) {
			absoluteString=[absoluteString substringToIndex:rang.location];
		}
		self.URL=[NSURL URLWithString:absoluteString];
	}
	else if([[self HTTPMethod] isEqualToString:@"GET"] ||[[self HTTPMethod] isEqualToString:@"DELETE"])
	{
		encodeParameters=[[self URL] query];
		
	}else {
		shouldfree=YES;
		encodeParameters=[[NSString alloc] initWithData:[self HTTPBody] encoding:NSASCIIStringEncoding];

	}
	if ((encodeParameters==nil)||([encodeParameters isEqualToString:@""])) {
        if (shouldfree) {
            [encodeParameters release];
        }
		return nil;
	}

	NSArray *encodedParameterPairs=[encodeParameters componentsSeparatedByString:@"&"];
	NSMutableArray *requestParameters=[[NSMutableArray alloc] initWithCapacity:16];
	
	for (NSString *encodedPair in encodedParameterPairs) {
		NSArray *encodedPairElements=[encodedPair componentsSeparatedByString:@"="];

		RequestParameter *parameter=[[RequestParameter alloc] initWithName:[[encodedPairElements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] value:[[encodedPairElements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[requestParameters addObject:parameter];
		[parameter release];
	}
	if (shouldfree) {
		[encodeParameters release];
	}
	
	return[requestParameters autorelease];
	
}

-(void)setParameters:(NSArray *)aParameters
{
	NSMutableString *encodedParameterPairs=[NSMutableString stringWithCapacity:256];
	int position=1;
	for (RequestParameter *requestParameter in aParameters) {
		[encodedParameterPairs appendString:[requestParameter URLEncodedNameValuePair]];
		if (position<[aParameters count]) {
			[encodedParameterPairs appendString:@"&"];
		}
		position++;
	}
	if ([[self HTTPMethod] isEqualToString:@"GET"]||[[self HTTPMethod] isEqualToString:@"DELETE"]) {
		[self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",[[self URL] URLStringWithoutQuery],encodedParameterPairs]]];
	}else {
		NSData *postData = [encodedParameterPairs dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		[self setHTTPBody:postData];
		[self setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
		[self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	}

}

@end
