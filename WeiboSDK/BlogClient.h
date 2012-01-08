//
//  BlogClient.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-29.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Additions.h"
#import "OAuth.h"
#import "WeiboUser.h"

@interface BlogClient : NSObject {
	BOOL isHttps;
	OAuth *oauth;
	WeiboUser *user;
}

@property BOOL isHttps;
@property (nonatomic,retain)OAuth *oauth;
@property (nonatomic,retain)WeiboUser *user;

-(id)initWithConsumerKey:(NSString *)aConsumerKey consumerSecret:(NSString *)aConsumerSecret;
-(void)setAccessKey:(NSString *)key secret:(NSString *)secret;
-(UIViewController *)getOAuthViewController:(id)delegate;
-(BOOL)isAuthorized;
-(void)public_timeline:(int)aCount base_app:(int)aBase_app delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)friends_timeline:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)friends_timeline:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage base_app:(int)aBase_app feature:(int)aFeature delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)mentions:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)comments_timeline:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)comments_by_me:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)comments_to_me:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)comments:(long long)comment_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)repost_timeline:(long long)status_id since_id:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)repost_by_me:(long long)status_id since_id:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)unread:(int)with_new_status since_id:(long long)aSince_id delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)reset_count:(int)aType delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)user_timeline:(NSString *)user_id since_id:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage base_app:(int)aBase_app feature:(int)aFeature delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)update:(NSString *)tweet delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)upload:(NSString *)tweet imageUlr:(NSString *)url delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)upload:(NSString *)tweet image:(NSData *)aImage filename:(NSString *)aFilename contentType:(NSString *)aContentType delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)statusRepost:(long long)statusId status:(NSString*)tweet is_comment:(int)aIs_comment delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)statusComment:(long long)status_id comment:(NSString *)aComment cid:(long long)aCid without_mention:(int)aWithout_mention comment_ori:(int)aComment_ori delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)comment_destroy:(long long)comment_id delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)destroy_batch:(NSString *)ids delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)statusDestroy:(long long)statusId delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)show:(NSString *)ID user_id:(NSString *) aUserId screen_name:(NSString *)aScreenName delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)statusShow:(long long)statusId delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)statusesCounts:(NSString *)ids delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)emotions:(NSString *)type language:(NSString *)lan delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)reply:(long long)cid comment:(NSString *)aComment statusId:(long long)status_id without_mention:(int)aWithout_mention delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)friends:(long long)user_id screen_name:(NSString *)name cursor:(int)aCursor count:(int)aCount delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)followers:(long long)user_id screen_name:(NSString *)name cursor:(int)aCursor count:(int)aCount delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)hot:(NSString *)category delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)update_remark:(long long)user_id remark:(NSString *)aRemark delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)suggestions:(int)with_reason delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)friendshipsCreate:(long long)user_id screen_name:(NSString *)name delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)friendshipsDestroy:(long long)user_id screen_name:(NSString *)name delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)friendshipsExists:(long long)user_a user_b:(long long)user_b delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)favorites:(int)page delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)favoritesCreate:(long long)status_id delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)favoritesDestroy:(long long)status_id delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
-(void)favoritesDestroy_batch:(NSString *)ids delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail;
@end
