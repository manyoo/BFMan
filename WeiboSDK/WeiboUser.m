//
//  User.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-5.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "WeiboUser.h"


@implementation WeiboUser

@synthesize userId;
@synthesize screen_name;
@synthesize name;
@synthesize province;
@synthesize city;
@synthesize location;
@synthesize description;
@synthesize url;
@synthesize profile_image_url;
@synthesize domain;
@synthesize gender;
@synthesize followers_count;
@synthesize friends_count;
@synthesize statuses_count;
@synthesize favourites_count;
@synthesize created_at;
@synthesize following;
@synthesize verified;
@synthesize key;
@synthesize secret;
@synthesize icon;

-(WeiboUser *)init
{
	if (self=[super init]) {
		
	}
	return self;
}

-(WeiboUser*)initWithDictionary:(NSDictionary*)dic
{
	if (self=[super init]) {
		
		self.userId=[dic objectForKey:@"id"];
		self.screen_name=[dic objectForKey:@"screen_name"];
		self.name=[dic objectForKey:@"name"];
		self.province=[[dic objectForKey:@"province"]intValue];
		self.city=[[dic objectForKey:@"city"]intValue];
		self.location=[dic objectForKey:@"location"];
		self.description=[dic objectForKey:@"description"];
		self.url=[dic objectForKey:@"url"];
		self.profile_image_url=[dic	objectForKey:@"profile_image_url"];
		self.domain=[dic objectForKey:@"domain"];
		
		NSString *genderChar=[dic objectForKey:@"gender"];
		if ([genderChar isEqualToString:@"m"]) {
			self.gender=Male;
		}else if ([genderChar isEqualToString:@"f"]) {
			self.gender=Female;
		}else {
			self.gender=Unknow;
		}
		self.followers_count=([dic objectForKey:@"followers_count"]==[NSNull null])?0:[[dic objectForKey:@"followers_count"]longValue];
		self.friends_count=([dic objectForKey:@"friends_count"]==[NSNull null])?0:[[dic objectForKey:@"friends_count"]longValue];
		self.statuses_count=([dic objectForKey:@"statuses_count"]==[NSNull null])?0:[[dic objectForKey:@"statuses_count"]longValue];
		self.favourites_count=([dic objectForKey:@"favourites_count"]==[NSNull null])?0:[[dic objectForKey:@"favourites_count"]longValue];
		NSString *stringOfCreated_at=[dic objectForKey:@"created_at"];
		if ((id)stringOfCreated_at==[NSNull null]) {
			stringOfCreated_at=@"";
		}
		self.created_at=convertTimeStamp(stringOfCreated_at);
		self.following=([dic objectForKey:@"following"]==[NSNull null])?0:[[dic objectForKey:@"following"]boolValue];
		self.verified=([dic objectForKey:@"verified"]==[NSNull null])?0:[[dic objectForKey:@"verified"]boolValue];
	}
	return self;
}

-(void)dealloc
{
	[userId release];
	[screen_name release];
	[name release];
	[location release];
	[description release];
	[url release];
	[profile_image_url release];
	[domain release];
	
	[key release];
	[secret release];
	[icon release];
	
	[super dealloc];
}

@end
