//
//  Status.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-5.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "Status.h"


@implementation Status
@synthesize statusId;
@synthesize created_at;
@synthesize text;
@synthesize source;
@synthesize sourceUrl;
@synthesize favorited;
@synthesize truncated;
@synthesize in_reply_to_status_id;
@synthesize in_reply_to_user_id;
@synthesize in_reply_to_screen_name;
@synthesize thumbnail_pic;
@synthesize bmiddle_pic;
@synthesize original_pic;
@synthesize user;
@synthesize retweeted_status;
@synthesize comments;
@synthesize rt;

-(id)initWithJsonDictionary:(NSDictionary*)dic
{
	if (self=[super init]) {
		
		self.statusId=[dic getLongLongValueForKey:@"id" defaultValue:-1];
		self.created_at=[dic getTimeValueForKey:@"created_at" defaultValue:0];
		self.text=[dic getStringValueForKey:@"text" defaultValue:@""];
		NSString *src=[dic getStringValueForKey:@"source" defaultValue:@""];

		NSRange r=[src rangeOfString:@"<a href"];
		if (r.location!=NSNotFound) {
			
			NSRange start=[src rangeOfString:@"<a href=\""];
			if (start.location!=NSNotFound) {
				int l=[src length];
				NSRange fRange=NSMakeRange(start.location+start.length, l-start.length-start.location);
				NSRange eRange=[src rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:fRange];
				if (eRange.location!=NSNotFound) {
					
					r.location=start.location+start.length;
					r.length=eRange.location-r.location;
					self.sourceUrl=[src substringWithRange:r];
					
				}else {
					self.sourceUrl=@"";
				}
				
			}else {
				self.sourceUrl=@"";
			}
			start=[src rangeOfString:@"\">"];
			NSRange end=[src rangeOfString:@"</a>"];
			if (start.location!=NSNotFound && end.location!=NSNotFound) {
				r.location = start.location + start.length;
				r.length = end.location - r.location;
				self.source = [src substringWithRange:r];
				
			}else {
				self.source=@"";
			}

		}else {
			self.source=src;
			
		}
		
		self.favorited=[dic getBoolValueForKey:@"favorited" defaultValue:NO];
		self.truncated=[dic getBoolValueForKey:@"truncated" defaultValue:NO];
		
		self.in_reply_to_status_id=[dic getLongLongValueForKey:@"in_reply_to_status_id" defaultValue:-1];
		self.in_reply_to_user_id=[dic getIntValueForKey:@"in_reply_to_user_id" defaultValue:-1];
		self.in_reply_to_screen_name=[dic getStringValueForKey:@"in_reply_to_screen_name" defaultValue:@""];
		self.thumbnail_pic=[dic getStringValueForKey:@"thumbnail_pic" defaultValue:@""];
		self.bmiddle_pic=[dic getStringValueForKey:@"bmiddle_pic" defaultValue:@""];
		self.original_pic=[dic getStringValueForKey:@"original_pic" defaultValue:@""];
		
		NSDictionary *userDic=[dic objectForKey:@"user"];
		if (userDic) {
			WeiboUser *u=[[WeiboUser alloc]initWithDictionary:userDic];
			self.user=u;
			[u release];
		}
		NSDictionary *retweetedStatusDic=[dic objectForKey:@"retweeted_status"];
		if (retweetedStatusDic) {
			Status *s =[[Status alloc]initWithJsonDictionary:retweetedStatusDic];
			self.retweeted_status=s;
			[s release];
		}

	}
	return self;
}

-(void)dealloc
{
	[text release];
	[source release];
	[sourceUrl release];
	[in_reply_to_screen_name release];
	[thumbnail_pic release];
	[bmiddle_pic release];
	[original_pic release];
	[user release];
	[retweeted_status release];
	
	[super dealloc];
}

@end
