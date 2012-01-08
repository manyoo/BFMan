//
//  OAuth.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "OAuth.h"
#import "Consumer.h"
#import "HttpClient.h"
#import "OAMutableURLRequest.h"
#import "Token.h"


#define ACCESS_TOKEN_FILE @"weibo_access"

@interface OAuth(private)

-(void)requestRequestTokenSuccess:(NSData *)data;
-(void)requestRequestTokenFail:(NSError *)error;
-(void)requestAccessTokenSuccess:(NSData *)data;
-(void)requestAccessTokenFail:(NSData *)data;
-(NSString *)getUserIDFromHTTPBody:(NSString *)body;
-(void)saveAccessKeyToFile;

@end


@implementation OAuth

@synthesize consumerKey,consumerSecret;
@synthesize requestTokenURL,accessTokenURL,authorizeURL;
@synthesize consumer;
@synthesize requestToken;
@synthesize accessToken;
@synthesize userID;

-(id)init
{
	if (self=[super init]) {
		self.requestTokenURL= [NSURL URLWithString: @"http://api.t.sina.com.cn/oauth/request_token"];
		self.accessTokenURL = [NSURL URLWithString: @"http://api.t.sina.com.cn/oauth/access_token"];
		self.authorizeURL = [NSURL URLWithString: @"http://api.t.sina.com.cn/oauth/authorize"];
	}
	return self;
}

-(void)requestRequestTokenSuccess:(NSData *)data
{
	NSString *dataString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];

	Token *tn=[[Token alloc] initWithHTTPResponseBody:dataString];
	self.requestToken=tn;
	[tn release];
	[dataString release];
}

-(void)requestRequestTokenFail:(NSError *)error
{
	NSString* msg = [NSString stringWithFormat:@"%@ %@",[error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
	NSLog(@"%@",msg);
}

-(void)requestRequestToken 
{
	HttpClient *httpClinet=[[HttpClient alloc]init];
	OAMutableURLRequest *request=[[OAMutableURLRequest alloc]initWithURL:self.requestTokenURL consumer:self.consumer token:nil];
	[request setHTTPMethod:@"POST"];
	[request prepare];
	[httpClinet request:request delegate:self onSuccess:@selector(requestRequestTokenSuccess:) onFail:@selector(requestRequestTokenFail:)];
	[request release];
	[httpClinet release];
}

-(void)requestAccessTokenSuccess:(NSData *)data
{
	NSString *dataString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
	Token *tn= [[Token alloc] initWithHTTPResponseBody:dataString];
	self.accessToken=tn;
    [self saveAccessKeyToFile];
    
	NSString *_userID=[self getUserIDFromHTTPBody:dataString];
	if (_userID) {
		self.userID=_userID;
	}
    
	[tn release];
	[dataString release];
}

-(void)requestAccessTokenFail:(NSData *)data
{
	NSString *dataString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
	
	NSLog(@"AccessError:%@",[dataString URLDecodedString]);
	[dataString release];
}

-(void)requestAccessToken
{
	HttpClient *httpClinet=[[HttpClient alloc]init];
	OAMutableURLRequest *request=[[OAMutableURLRequest alloc]initWithURL:self.accessTokenURL consumer:self.consumer token:requestToken];
	[request setHTTPMethod:@"POST"];
	[request prepare];
	[httpClinet request:request delegate:self onSuccess:@selector(requestAccessTokenSuccess:) onFail:@selector(requestAccessTokenFail:)];
	[request release];
	[httpClinet release];
}

-(NSURLRequest *) authorizeURLRequest
{
	if (self.requestToken.key && self.requestToken.secret) {
		NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:self.authorizeURL];
		[request setParameters: [NSArray arrayWithObject: [[[RequestParameter alloc] initWithName: @"oauth_token" value: requestToken.key] autorelease]]];	
		return [request autorelease];
		
	}else {
		return nil;
	}

}

-(void)SignGet:(NSURL *)url delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	HttpClient *httpClinet=[[HttpClient alloc]init];
	OAMutableURLRequest *request=[[OAMutableURLRequest alloc]initWithURL:url consumer:self.consumer token:accessToken];
	[request prepare];
	[httpClinet get:request delegate:aDelegate onSuccess:aSuccess onFail:aFail];
	[request release];
	[httpClinet release];
}

-(void)SignPost:(NSURL *)url body:aBody delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	HttpClient *httpClinet=[[HttpClient alloc]init];
	OAMutableURLRequest *request=[[OAMutableURLRequest alloc]initWithURL:url consumer:self.consumer token:accessToken];
	 [httpClinet setPost:request body:aBody];
	[request prepare];
	[httpClinet post:request delegate:aDelegate onSuccess:aSuccess onFail:aFail];
	[request release];
	[httpClinet release];
}

-(void)SignPost:(NSURL *)url params:(NSDictionary *)aParams data:(NSData *)aData filename:(NSString *)aFilename contentType:(NSString *)aContentType delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	HttpClient *httpClinet=[[HttpClient alloc]init];
	OAMutableURLRequest *request=[[OAMutableURLRequest alloc]initWithURL:url consumer:self.consumer token:accessToken];
	[httpClinet setMultipartFormDataPost:request params:aParams data:aData filename:aFilename contentType:aContentType];
	[request prepare];
	[httpClinet post:request delegate:aDelegate onSuccess:aSuccess onFail:aFail];
	[request release];
	[httpClinet release];
}

-(void)SignRequest:(NSURL *)url httpMethod:(NSString *)aHttpMethod delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	
}

-(NSString *)getUserIDFromHTTPBody:(NSString *)body
{
	if (!body) {
		return nil;
	}
	NSArray *tuples=[body componentsSeparatedByString:@"&"];
	if (tuples.count<1) {
		return nil;
	}
	for (NSString *tuple in tuples) {
		NSArray *keyValArray=[tuple componentsSeparatedByString:@"="];
		NSString *key=[keyValArray objectAtIndex:0];
		NSString *val=[keyValArray objectAtIndex:1];
		if ([key isEqualToString:@"user_id"]) {
			return val;
		}
	}
	return nil;
}

-(Consumer *)consumer
{
	if (_consumer) {
		return _consumer;
	}
	if ([self.consumerKey length]>0 && [self.consumerSecret length]>0) {
		_consumer=[[Consumer alloc] initWithKey:self.consumerKey secret:self.consumerSecret];
		return _consumer;
	}
	return nil;
}

-(void)setPin:(NSString *)aPin
{
	pin=[aPin retain];
    requestToken.pin=pin;
}

-(void)saveAccessKeyToFile {
    NSString *key = self.accessToken.key;
    NSString *secret = self.accessToken.secret;
    
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSURL *documentDir;
    if ([urls count] > 0) {
        documentDir = [urls objectAtIndex:0];
        
        NSURL *fileUrl = [NSURL URLWithString:ACCESS_TOKEN_FILE relativeToURL:documentDir];
        
        NSString *t = [NSString stringWithFormat:@"%@\n%@",key,secret];
        [t writeToURL:fileUrl atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

-(void)setAccessKey:(NSString *)key secret:(NSString *)secret
{
	Token *tn=[[Token alloc] init];
	tn.key=key;
	tn.secret=secret;
	
	self.accessToken=tn;
	[tn release];
    
    if (key != nil && secret != nil) {
        [self saveAccessKeyToFile];
    }
}


-(NSString *)key
{
	return [[accessToken.key copy] autorelease];
}
-(NSString *)secret
{
	return [[accessToken.secret copy] autorelease];
}

-(BOOL)isAuthorized
{
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    
    NSURL *documentDir;
    if ([urls count] > 0) {
        documentDir = [urls objectAtIndex:0];    
        
        NSURL *fileUrl = [NSURL URLWithString:ACCESS_TOKEN_FILE relativeToURL:documentDir];
        
        BOOL hasFile = [[NSFileManager defaultManager] fileExistsAtPath:[fileUrl path]];
        if (hasFile) {
            if (accessToken == nil) {
                Token *tn = [[Token alloc] init];
                self.accessToken = tn;
                [tn release];
            }
            NSString *data = [NSString stringWithContentsOfURL:fileUrl encoding:NSUTF8StringEncoding error:nil];
            NSArray *rows = [data componentsSeparatedByString:@"\n"];
            accessToken.key = [rows objectAtIndex:0];
            accessToken.secret = [rows objectAtIndex:1];
        }
    }
    
	if (accessToken.key && accessToken.secret) {
		return YES;
	} else {
		return NO;
	}
}

-(BOOL)haveRequestToken
{
	if(requestToken)
	{
		return YES;
	}else {
		return NO;
	}

}

-(void)dealloc
{
	[consumerKey release];
	[consumerSecret release];
	[requestTokenURL release];
	[accessTokenURL release];
	[authorizeURL release];
	[_consumer release];
	[requestToken release];
	[accessToken release];
	[pin release];
	[userID release];
	
	[super dealloc];
}

@end
