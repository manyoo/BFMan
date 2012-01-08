//
//  OAuth.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>
@class Consumer;
@class HttpClient;
@class OAMutableURLRequest;
@class Token;

@interface OAuth : NSObject {
	
	NSString *consumerKey;
	NSString *consumerSecret;
	NSURL *requestTokenURL;
	NSURL *accessTokenURL;
	NSURL *authorizeURL;
	Consumer *_consumer;
	
	Token *requestToken;
	Token *accessToken;
	
	NSString *pin;
	NSString *userID;
}

@property (nonatomic,retain)NSString *consumerKey,*consumerSecret;
@property (nonatomic,retain)NSURL *requestTokenURL,*accessTokenURL,*authorizeURL;
@property (nonatomic,retain)Consumer *consumer;
@property (nonatomic,retain)Token *requestToken;
@property (nonatomic,retain)Token *accessToken;
@property (nonatomic,retain)NSString *userID;

-(void)requestRequestToken;
-(void)requestAccessToken;
-(void)SignGet:(NSURL *)url delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)SignPost:(NSURL *)url body:aBody delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)SignPost:(NSURL *)url params:(NSDictionary *)aParams data:(NSData *)aData filename:(NSString *)aFilename contentType:(NSString *)aContentType delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)SignRequest:(NSURL *)url httpMethod:(NSString *)aHttpMethod delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(NSURLRequest *) authorizeURLRequest;
-(BOOL)isAuthorized;
-(BOOL)haveRequestToken;

-(void)setPin:(NSString *)aPin;
-(void)setAccessKey:(NSString *)key secret:(NSString *)secret;
-(NSString *)key;
-(NSString *)secret;

@end
