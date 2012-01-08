//
//  Status.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-5.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboUser.h"
#import "NSDictionary+GetValue.h"

@interface Status : NSObject {

	long long statusId;
	time_t created_at;
	NSString *text;
	NSString *source;
	NSString *sourceUrl;
	BOOL favorited;
	BOOL truncated;
	long long in_reply_to_status_id;
	int in_reply_to_user_id;
	NSString *in_reply_to_screen_name;
	NSString *thumbnail_pic;
	NSString *bmiddle_pic;
	NSString *original_pic;
	WeiboUser *user;
	Status *retweeted_status;
	long long comments;
	long long rt;
	
}

@property (nonatomic,assign)long long statusId;
@property (nonatomic,assign)time_t created_at;
@property (nonatomic,retain)NSString *text;
@property (nonatomic,retain)NSString *source;
@property (nonatomic,retain)NSString *sourceUrl;
@property (nonatomic, assign)BOOL favorited;
@property (nonatomic,assign)BOOL truncated;
@property (nonatomic,assign)long long in_reply_to_status_id;
@property (nonatomic,assign)int in_reply_to_user_id;
@property (nonatomic,retain)NSString *in_reply_to_screen_name;
@property (nonatomic,retain)NSString *thumbnail_pic;
@property (nonatomic,retain)NSString *bmiddle_pic;
@property (nonatomic,retain)NSString *original_pic;
@property (nonatomic,retain)WeiboUser *user;
@property (nonatomic,retain)Status *retweeted_status;
@property (nonatomic,assign)long long comments;
@property (nonatomic,assign)long long rt;

-(id)initWithJsonDictionary:(NSDictionary*)dic;

@end
