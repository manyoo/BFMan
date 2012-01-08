//
//  comment.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-26.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+GetValue.h"
#import "WeiboUser.h"
#import "Status.h"

@interface comment : NSObject {
	long long commentId;
	NSString *text;
	NSString *source;
	NSString *sourceUrl;
	BOOL favorited;
	BOOL truncated;
	time_t created_at;
	WeiboUser *user;
	Status *status;
	comment *reply_comment;
}

@property (nonatomic,assign)long long commentId;
@property (nonatomic,retain)NSString *text;
@property (nonatomic,retain)NSString *source;
@property (nonatomic,retain)NSString *sourceUrl;
@property (nonatomic,assign)BOOL favorited;
@property (nonatomic,assign)BOOL truncated;
@property (nonatomic,assign)time_t created_at;
@property (nonatomic,retain)WeiboUser *user;
@property (nonatomic,retain)Status *status;
@property (nonatomic,retain)comment *reply_comment;

-(id)initWithJson:(NSDictionary*)dic;

@end
