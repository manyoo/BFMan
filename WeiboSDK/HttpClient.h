//
//  HttpClient.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFC1867.h"

@interface HttpClient : NSObject {

	NSError *_error;
	NSURLResponse *_response;
	NSData *_responseData;
	NSURLConnection *connection;
	int statusCode;
	NSMutableData* buf;
	id delegate;
	SEL onSuccess;
	SEL onFail;
	
}

@property(nonatomic,retain)NSURLConnection *connection;
@property(nonatomic,retain)NSMutableData* buf;
@property(nonatomic,retain)id delegate;

-(void)request:(NSMutableURLRequest *)aRequest delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)request:(NSMutableURLRequest *)aRequest httpMethod:(NSString *)aHttpMedthod delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)get:(NSMutableURLRequest *)aRequest delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;

-(void)setPost:(NSMutableURLRequest *)aRequest body:(NSString *)aBody;
-(void)post:(NSMutableURLRequest *)aRequest delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)post:(NSMutableURLRequest *)aRequest body:(NSString *)aBody delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)setMultipartFormDataPost:(NSMutableURLRequest *)aRequest params:(NSDictionary *)aParams data:(NSData *)aData filename:(NSString *)aFilename contentType:(NSString *)aContentType;


@end
