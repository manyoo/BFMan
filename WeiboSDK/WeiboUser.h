//
//  User.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-5.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalFunc.h"

typedef enum
{
	Unknow,
	Male,
	Female,
}Gender;

@interface WeiboUser : NSObject {

	NSString *userId;
	NSString *screen_name;
	NSString *name;
	int province;
	int city;
	NSString *location;
	NSString *description;
	NSString *url;
	NSString *profile_image_url;
	NSString *domain;
	Gender gender;
	int followers_count;
	int friends_count;
	int statuses_count;
	int favourites_count;
	time_t created_at;
	BOOL following;
	BOOL verified;
	NSString *key;
	NSString *secret;
	UIImage *icon;
}

@property (nonatomic,retain)NSString *userId;
@property (nonatomic,retain)NSString *screen_name;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,assign)int province;
@property (nonatomic,assign)int city;
@property (nonatomic,retain)NSString *location;
@property (nonatomic,retain)NSString *description;
@property (nonatomic,retain)NSString *url;
@property (nonatomic,retain)NSString *profile_image_url;
@property (nonatomic,retain)NSString *domain;
@property (nonatomic,assign)Gender gender;
@property (nonatomic,assign)int followers_count;
@property (nonatomic,assign)int friends_count;
@property (nonatomic,assign)int statuses_count;
@property (nonatomic,assign)int favourites_count;
@property (nonatomic,assign)time_t created_at;
@property (nonatomic,assign)BOOL following;
@property (nonatomic,assign)BOOL verified;

@property (nonatomic,retain)NSString *key;
@property (nonatomic,retain)NSString *secret;
@property (nonatomic,retain)UIImage *icon;

-(WeiboUser *)init;
-(WeiboUser*)initWithDictionary:(NSDictionary*)dic;


@end
