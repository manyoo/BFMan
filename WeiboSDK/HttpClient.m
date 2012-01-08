//
//  HttpClient.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "HttpClient.h"
#import "SBJson.h"


@implementation HttpClient

@synthesize connection;
@synthesize buf;
@synthesize delegate;

-(void)request:(NSMutableURLRequest *)aRequest delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	[self request:aRequest httpMethod:@"POST" delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

-(void)request:(NSMutableURLRequest *)aRequest httpMethod:(NSString *)aHttpMedthod delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	
	if (!aRequest) {
		return;
	}
	[aRequest setHTTPMethod:aHttpMedthod];
	_responseData=[NSURLConnection sendSynchronousRequest:aRequest  returningResponse:&_response error:&_error];

	if (_response==nil || _responseData==nil || _error!=nil) 
	{
		[aDelegate performSelector:aFail withObject:_error];
		
	}else {
		[aDelegate performSelector:aSuccess withObject:_responseData];
	}
}

-(void)get:(NSMutableURLRequest *)aRequest delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{

	statusCode=0;
	
	self.delegate=aDelegate;
	onSuccess=aSuccess;
	onFail=aFail;
	
	self.buf=[NSMutableData data];
	
	connection= [[NSURLConnection alloc] initWithRequest:aRequest delegate:self];
	
	//while (self.connection!=nil) {
	//	[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	//}
	[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;

}

-(void)setPost:(NSMutableURLRequest *)aRequest body:(NSString *)aBody
{
	[aRequest setHTTPMethod:@"POST"];
	[aRequest setHTTPShouldHandleCookies:NO];
	[aRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	int contentLength=[aBody lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	[aRequest setValue:[NSString stringWithFormat:@"%d", contentLength] forHTTPHeaderField:@"Content-Length"];
	NSString *finalBody=[NSString stringWithString:@""];
	if (aBody) {
		finalBody=[finalBody stringByAppendingString:aBody];
	}
	[aRequest setHTTPBody:[finalBody dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)post:(NSMutableURLRequest *)aRequest delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	statusCode=0;
	self.delegate=aDelegate;
	onSuccess=aSuccess;
	onFail=aFail;
	self.buf=[NSMutableData data];
	connection= [[NSURLConnection alloc] initWithRequest:aRequest delegate:self];
	[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
}

-(void)post:(NSMutableURLRequest *)aRequest body:(NSString *)aBody delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	statusCode=0;
	[self setPost:aRequest body:aBody];
	self.delegate=aDelegate;
	onSuccess=aSuccess;
	onFail=aFail;
	self.buf=[NSMutableData data];
	connection= [[NSURLConnection alloc] initWithRequest:aRequest delegate:self];
	[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
}

-(void)setMultipartFormDataPost:(NSMutableURLRequest *)aRequest params:(NSDictionary *)aParams data:(NSData *)aData filename:(NSString *)aFilename contentType:(NSString *)aContentType
{
	RFC1867 *rfc=[[RFC1867 alloc] init];
	NSMutableData *data=[rfc getMultipartFormData:aParams data:aData name:@"pic" filename:aFilename contentType:aContentType];

	[aRequest setHTTPMethod:@"POST"];
	[aRequest setHTTPShouldHandleCookies:NO];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", rfc.FORM_BOUNDARY];
	[aRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [aRequest setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
	[aRequest setHTTPBody:data];
	
	[rfc release];
}

-(void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
	NSHTTPURLResponse *resp=(NSHTTPURLResponse *)aResponse;
	if (resp) {
		statusCode=resp.statusCode;
		//NSLog(@"Response: %d", statusCode);
	}
	[buf setLength:0];
	
}

-(void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
	[buf appendData:data];
}

-(void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error
{
	NSNumber *code=[[[NSNumber alloc] initWithInt:statusCode] autorelease];
	NSString* msg = [NSString stringWithFormat:@"%@ %@",[error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
	
	 NSLog(@"Connection failed: %@", msg);
	[delegate performSelector:onFail 
				   withObject:code 
				   withObject:msg];
	
	self.connection=nil;
	self.buf=nil;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	
    
   
}

-(void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	NSString* s = [[[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding] autorelease];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *json = [parser objectWithString:s];
    
	if (delegate) {
		NSNumber *code=[[[NSNumber alloc] initWithInt:statusCode] autorelease];
		if (statusCode==200) {
			[delegate performSelector:onSuccess 
						   withObject:code 
						   withObject:json];
		}else {
			[delegate performSelector:onFail 
						   withObject:code 
						   withObject:s];
		}

		
	}
	[parser release];
	self.connection=nil;
	self.buf=nil;
}

-(void)dealloc
{
	[connection release];
	[buf release];
	[delegate release];
	[super dealloc];
}

@end
