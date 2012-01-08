//
//  comment.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-26.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "comment.h"


@implementation comment
@synthesize commentId;
@synthesize text;
@synthesize source;
@synthesize sourceUrl;
@synthesize favorited;
@synthesize truncated;
@synthesize created_at;
@synthesize user;
@synthesize status;
@synthesize reply_comment;

-(id)initWithJson:(NSDictionary*)dic
{
	if (self=[super init]) {
		self.commentId=[dic getLongLongValueForKey:@"id" defaultValue:-1];
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
		self.created_at=[dic getTimeValueForKey:@"created_at" defaultValue:0];
		NSDictionary *userDic=[dic objectForKey:@"user"];
		if (userDic) {
			WeiboUser *u=[[WeiboUser alloc]initWithDictionary:userDic];
			self.user=u;
			[u release];
		}
		NSDictionary *statusDic=[dic objectForKey:@"status"];
		if (statusDic) {
			Status *st=[[Status alloc]initWithJsonDictionary:statusDic];
			self.status=st;
			[st release];
		}
		NSDictionary *reply_commentDic=[dic objectForKey:@"reply_comment"];
		if (reply_commentDic) {
			comment *s =[[comment alloc]initWithJson:reply_commentDic];
			self.reply_comment=s;
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
	[user release];
	[status release];
	[reply_comment release];
	[super dealloc];
}

@end
