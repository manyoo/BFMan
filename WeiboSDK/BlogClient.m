//
//  BlogClient.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-29.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "BlogClient.h"
#import "OAuthViewController.h"

#define API_FORMAT @"json"
#define API_DOMAIN	@"api.t.sina.com.cn"

@interface BlogClient(private)

-(NSURL *)getURL:(NSString *)path queryParameters:(NSMutableDictionary*)params prefixed:(BOOL)prefixed;

@end


@implementation BlogClient
@synthesize isHttps;
@synthesize oauth;
@synthesize user;

-(id)initWithConsumerKey:(NSString *)aConsumerKey consumerSecret:(NSString *)aConsumerSecret
{
	if (self=[super init]) {
		isHttps=NO;
		oauth=[[OAuth alloc] init];
		oauth.consumerKey=aConsumerKey;
		oauth.consumerSecret=aConsumerSecret;
	}
	return self;
}

-(UIViewController *)getOAuthViewController:(id)delegate
{
	[oauth requestRequestToken];
	if ([oauth haveRequestToken]) {
		OAuthViewController *controller=[[OAuthViewController alloc]initWithOAuth:oauth delegate:delegate];
		return [controller autorelease];
	}
	return nil;
}

//返回最新的20条公共微博。返回结果非完全实时，最长会缓存60秒
-(void)public_timeline:(int)aCount base_app:(int)aBase_app delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/public_timeline.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (aCount>-1) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	if (aBase_app>-1) {
		[params setObject:[NSString stringWithFormat:@"%d",aBase_app] forKey:@"base_app"];
	}

	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//获取当前登录用户及其所关注用户的最新微博消息。和用户登录 http://t.sina.com.cn 后在“我的首页”中看到的内容相同
-(void)friends_timeline:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	[self friends_timeline:-1 max_id:-1 count:aCount page:aPage base_app:0 feature:0 delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//获取当前登录用户及其所关注用户的最新微博消息。和用户登录 http://t.sina.com.cn 后在“我的首页”中看到的内容相同
-(void)friends_timeline:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage base_app:(int)aBase_app feature:(int)aFeature delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/friends_timeline.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (aSince_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aSince_id] forKey:@"since_id"];
	}
	if (aMax_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aMax_id] forKey:@"max_id"];
	}
	if (aCount>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	if (aPage>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aPage] forKey:@"page"];
	}
	if (aBase_app>-1) {
		[params setObject:[NSString stringWithFormat:@"%d",aBase_app] forKey:@"base_app"];
	}
	if (aFeature>-1) {
		[params setObject:[NSString stringWithFormat:@"%d",aFeature] forKey:@"feature"];
	}
	
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
	
}

//返回用户最新发表的微博消息列表
-(void)user_timeline:(NSString *)user_id since_id:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage base_app:(int)aBase_app feature:(int)aFeature delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/user_timeline.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (user_id!=@"") {
		[params setObject:user_id forKey:@"user_id"];

	}
	if (aSince_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aSince_id] forKey:@"since_id"];
	}
	if (aMax_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aMax_id] forKey:@"max_id"];
	}
	if (aCount>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	if (aPage>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aPage] forKey:@"page"];
	}
	if (aBase_app>-1) {
		[params setObject:[NSString stringWithFormat:@"%d",aBase_app] forKey:@"base_app"];
	}
	if (aFeature>-1) {
		[params setObject:[NSString stringWithFormat:@"%d",aFeature] forKey:@"feature"];
	}
	
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
	
}

//返回最新n条提到登录用户的微博消息（即包含@username的微博消息）
-(void)mentions:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/mentions.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (aSince_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aSince_id] forKey:@"since_id"];
	}
	if (aMax_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aMax_id] forKey:@"max_id"];
	}
	if (aCount>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	if (aPage>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aPage] forKey:@"page"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
	
}

//返回最新n条发送及收到的评论
-(void)comments_timeline:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/comments_timeline.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (aSince_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aSince_id] forKey:@"since_id"];
	}
	if (aMax_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aMax_id] forKey:@"max_id"];
	}
	if (aCount>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	if (aPage>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aPage] forKey:@"page"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//获取当前用户发出的评论
-(void)comments_by_me:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/comments_by_me.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (aSince_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aSince_id] forKey:@"since_id"];
	}
	if (aMax_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aMax_id] forKey:@"max_id"];
	}
	if (aCount>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	if (aPage>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aPage] forKey:@"page"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//返回当前登录用户收到的评论
-(void)comments_to_me:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/comments_to_me.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (aSince_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aSince_id] forKey:@"since_id"];
	}
	if (aMax_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aMax_id] forKey:@"max_id"];
	}
	if (aCount>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	if (aPage>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aPage] forKey:@"page"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//根据微博消息ID返回某条微博消息的评论列表
-(void)comments:(long long)comment_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/comments.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld",comment_id] forKey:@"id"];
	if (aCount>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	if (aPage>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aPage] forKey:@"page"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//返回一条原创微博消息的最新n条转发微博消息。本接口无法对非原创微博进行查询。
-(void)repost_timeline:(long long)status_id since_id:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/repost_timeline.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld",status_id] forKey:@"id"];
	if (aSince_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aSince_id] forKey:@"since_id"];
	}
	if (aMax_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aMax_id] forKey:@"max_id"];
	}
	if (aCount>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	if (aPage>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aPage] forKey:@"page"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//获取用户最新转发的n条微博消息
-(void)repost_by_me:(long long)status_id since_id:(long long)aSince_id max_id:(long long)aMax_id count:(int)aCount page:(int)aPage delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/repost_by_me.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld",status_id] forKey:@"id"];
	if (aSince_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aSince_id] forKey:@"since_id"];
	}
	if (aMax_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aMax_id] forKey:@"max_id"];
	}
	if (aCount>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	if (aPage>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aPage] forKey:@"page"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//获取当前用户Web主站未读消息数，包括：
//是否有新微博消息
//最新提到“我”的微博消息数
//新评论数
//新私信数
//新粉丝数。
//此接口对应的清零接口为statuses/reset_count。
-(void)unread:(int)with_new_status since_id:(long long)aSince_id delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/unread.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];

	if (with_new_status>0) {
		[params setObject:[NSString stringWithFormat:@"%d",with_new_status] forKey:@"with_new_status"];
	}
	if (aSince_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",aSince_id] forKey:@"since_id"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//将当前登录用户的某种新消息的未读数为0。可以清零的计数类别有：1. 评论数，2. @me数，3. 私信数，4. 关注数
-(void)reset_count:(int)aType delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/reset_count.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%d",aType] forKey:@"type"];
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//发布一条微博信息。也可以同时转发某条微博。请求必须用POST方式提交
-(void)update:(NSString *)tweet delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/update.%@", API_FORMAT];
    NSString *postString = [NSString stringWithFormat:@"status=%@",[tweet encodeAsURIComponent]];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	
	[oauth SignPost:[self getURL:path queryParameters:params prefixed:YES] body:postString delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

-(void)upload:(NSString *)tweet imageUlr:(NSString *)url delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
    NSString *path = [NSString stringWithFormat:@"statuses/upload_url_text.%@", API_FORMAT];
    NSString *postString = [NSString stringWithFormat:@"status=%@&url=%@",[tweet encodeAsURIComponent],url];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [oauth SignPost:[self getURL:path queryParameters:params prefixed:YES] body:postString delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//发表图片微博消息。请求必须用POST方式提交(注意采用multipart/form-data编码方式)。目前上传图片大小限制为<5M。
-(void)upload:(NSString *)tweet image:(NSData *)aImage filename:(NSString *)aFilename contentType:(NSString *)aContentType delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/upload.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:tweet forKey:@"status"];
	
	[oauth SignPost:[self getURL:path queryParameters:params prefixed:YES] params:params data:aImage filename:aFilename contentType:aContentType delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//根据ID删除微博消息。注意：只能删除自己发布的微博消息
-(void)statusDestroy:(long long)statusId delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/destroy/%lld.%@", statusId,API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//转发一条微博消息。请求必须用POST方式提交。
-(void)statusRepost:(long long)status_id status:(NSString*)tweet is_comment:(int)aIs_comment delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/repost.%@", API_FORMAT];
    NSString *postString = [NSString stringWithFormat:@"status=%@",[tweet encodeAsURIComponent]];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld",status_id] forKey:@"id"];
	if (aIs_comment>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aIs_comment] forKey:@"is_comment"];
	}
	
	[oauth SignPost:[self getURL:path queryParameters:params prefixed:YES] body:postString delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//对一条微博信息进行评论。请求必须用POST方式提交。
-(void)statusComment:(long long)status_id comment:(NSString *)aComment cid:(long long)aCid without_mention:(int)aWithout_mention comment_ori:(int)aComment_ori delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/comment.%@", API_FORMAT];
    NSString *postString = [NSString stringWithFormat:@"comment=%@",[aComment encodeAsURIComponent]];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld",status_id] forKey:@"id"];
	if (aWithout_mention>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aWithout_mention] forKey:@"without_mention"];
	}
	if (aComment_ori>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aComment_ori] forKey:@"comment_ori"];
	}
	[oauth SignPost:[self getURL:path queryParameters:params prefixed:YES] body:postString delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//删除评论。注意：只能删除登录用户自己发布的评论，不可以删除其他人的评论。
-(void)comment_destroy:(long long)comment_id delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/comment_destroy/%lld.%@", comment_id,API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//批量删除评论。注意：只能删除登录用户自己发布的评论，不可以删除其他人的评论
-(void)destroy_batch:(NSString *)ids delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/comment/destroy_batch.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:ids forKey:@"ids"];
	[oauth SignPost:[self getURL:path queryParameters:params prefixed:YES] body:@"" delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//回复评论。请求必须用POST方式提交。
-(void)reply:(long long)cid comment:(NSString *)aComment statusId:(long long)status_id without_mention:(int)aWithout_mention delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/reply.%@", API_FORMAT];
    NSString *postString = [NSString stringWithFormat:@"comment=%@",[aComment encodeAsURIComponent]];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld",cid] forKey:@"cid"];
	[params setObject:[NSString stringWithFormat:@"%lld",status_id] forKey:@"id"];
	if (aWithout_mention>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aWithout_mention] forKey:@"without_mention"];
	}
	
	[oauth SignPost:[self getURL:path queryParameters:params prefixed:YES] body:postString delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//按用户ID或昵称返回用户资料以及用户的最新发布的一条微博消息
-(void)show:(NSString *)ID user_id:(NSString *) aUserId screen_name:(NSString *)aScreenName delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"users/show.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (![ID isEqualToString:@""]) {
		[params setObject:ID forKey:@"id"];
	}
	if (![aUserId isEqualToString:@""]) {
		[params setObject:aUserId forKey:@"user_id"];
	}
	if (![aScreenName isEqualToString:@""]) {
		[params setObject:aScreenName forKey:@"screen_name"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//根据ID获取单条微博消息，以及该微博消息的作者信息
-(void)statusShow:(long long)statusId delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/show/%lld.%@", statusId,API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//批量获取n条微博消息的评论数和转发数。一次请求最多可以获取100条微博消息的评论数和转发数
-(void)statusesCounts:(NSString *)ids delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/counts.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:ids forKey:@"ids"];
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//返回新浪微博官方所有表情、魔法表情的相关信息。包括短语、表情类型、表情分类，是否热门等。
-(void)emotions:(NSString *)type language:(NSString *)lan delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"emotions.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (![type isEqualToString:@""]) {
		[params setObject:type forKey:@"type"];
	}
	if (![lan isEqualToString:@""]) {
		[params setObject:lan forKey:@"language"];
	}

	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//获取用户关注列表及每个关注用户的最新一条微博，返回结果按关注时间倒序排列，最新关注的用户排在最前面
-(void)friends:(long long)user_id screen_name:(NSString *)name cursor:(int)aCursor count:(int)aCount delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/friends.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (user_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",user_id] forKey:@"user_id"];
	}
	if (name!=@"") {
		[params setObject:name forKey:@"screen_name"];
	}
	if (aCursor>-2) {
		[params setObject:[NSString stringWithFormat:@"%d",aCursor] forKey:@"cursor"];
	}
	if (aCount>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
	
}

//获取用户粉丝列表及每个粉丝的最新一条微博，返回结果按粉丝的关注时间倒序排列，最新关注的粉丝排在最前面。每次返回20个,通过cursor参数来取得多于20的粉丝。注意目前接口最多只返回5000个粉丝
-(void)followers:(long long)user_id screen_name:(NSString *)name cursor:(int)aCursor count:(int)aCount delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"statuses/followers.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (user_id>0) {
		[params setObject:[NSString stringWithFormat:@"%lld",user_id] forKey:@"user_id"];
	}
	if (name!=@"") {
		[params setObject:name forKey:@"screen_name"];
	}
	if (aCursor>-2) {
		[params setObject:[NSString stringWithFormat:@"%d",aCursor] forKey:@"cursor"];
	}
	if (aCount>0) {
		[params setObject:[NSString stringWithFormat:@"%d",aCount] forKey:@"count"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
	
}

//返回系统推荐的用户列表
-(void)hot:(NSString *)category delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"users/hot.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];

		[params setObject:category forKey:@"category"];

	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//更新当前登录用户所关注的某个好友的备注信息
-(void)update_remark:(long long)user_id remark:(NSString *)aRemark delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"user/friends/update_remark.%@", API_FORMAT];
    NSString *postString = [NSString stringWithFormat:@"remark=%@",[aRemark encodeAsURIComponent]];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld",user_id] forKey:@"user_id"];
	[oauth SignPost:[self getURL:path queryParameters:params prefixed:YES] body:postString delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//返回当前用户可能感兴趣的用户
-(void)suggestions:(int)with_reason delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"users/suggestions.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (with_reason>-1) {
		[params setObject:[NSString stringWithFormat:@"%d",with_reason] forKey:@"with_reason"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//关注一个用户。关注成功则返回关注人的资料，目前的最多关注2000人
-(void)friendshipsCreate:(long long)user_id screen_name:(NSString *)name delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"friendships/create.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *postString = nil;
	if (user_id>-1) {
		postString = [NSString stringWithFormat:@"user_id=%lld",user_id];
	}
	if (name!=@"") {
		//[params setObject:name forKey:@"screen_name"];
	}
    [oauth SignPost:[self getURL:path queryParameters:params prefixed:YES] body:postString delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//取消对某用户的关注
-(void)friendshipsDestroy:(long long)user_id screen_name:(NSString *)name delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"friendships/destroy.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (user_id>-1) {
		[params setObject:[NSString stringWithFormat:@"%lld",user_id] forKey:@"user_id"];
	}
	if (name!=@"") {
		[params setObject:name forKey:@"screen_name"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//查看用户A是否关注了用户B。如果用户A关注了用户B，则返回true，否则返回false
-(void)friendshipsExists:(long long)user_a user_b:(long long)user_b delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"friendships/exists.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld",user_a] forKey:@"user_a"];
	[params setObject:[NSString stringWithFormat:@"%lld",user_b] forKey:@"user_b"];
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//返回登录用户最近收藏的20条微博消息，和用户在主站上“我的收藏”页面看到的内容是一致的
-(void)favorites:(int)page delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"favorites.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	if (page>0) {
		[params setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
	}
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//收藏一条微博消息
-(void)favoritesCreate:(long long)status_id delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"favorites/create.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:[NSString stringWithFormat:@"%lld",status_id] forKey:@"id"];
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//删除微博收藏。注意：只能删除自己收藏的信息
-(void)favoritesDestroy:(long long)status_id delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"favorites/destroy/%lld.%@",status_id, API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[oauth SignGet:[self getURL:path queryParameters:params prefixed:YES] delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}

//删除微博收藏。注意：只能删除自己收藏的信息
-(void)favoritesDestroy_batch:(NSString *)ids delegate:(id)aDelegate onSuccess:(SEL)aSuccess onFail:(SEL)aFail
{
	NSString *path = [NSString stringWithFormat:@"favorites/destroy_batch.%@", API_FORMAT];
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
	[params setObject:ids forKey:@"ids"];
	[oauth SignPost:[self getURL:path queryParameters:params prefixed:YES] body:@"" delegate:aDelegate onSuccess:aSuccess onFail:aFail];
}


-(BOOL)isAuthorized
{
	return [oauth isAuthorized];
}

-(void)setAccessKey:(NSString *)key secret:(NSString *)secret;
{
	[oauth setAccessKey:key secret:secret];
}


-(NSURL *)getURL:(NSString *)path queryParameters:(NSMutableDictionary*)params prefixed:(BOOL)prefixed
{
	NSString* fullPath = [NSString stringWithFormat:@"%@://%@/%@", (isHttps) ? @"https" : @"http",API_DOMAIN, path];
	NSMutableString *str=[NSMutableString stringWithCapacity:0];
	[str appendString:fullPath];
	if (params) {
		NSArray *names = [params allKeys];
		for (int i=0; i<[names count]; i++) {
			if (i==0 && prefixed) {
				[str appendString:@"?"];
			}else if (i>0) {
				[str appendString:@"&"];
			}
			NSString *name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@", name, [[params objectForKey:name]URLEncodedString]]];
		}
	}
	NSURL *finalURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]];
	//NSLog(@"url:%@",finalURL);
	return finalURL;
}

-(void)dealloc
{
	[oauth release];
	[user release];
	[super dealloc];
}

@end
