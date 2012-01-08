//
//  RequestParameter.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestParameter : NSObject {
	
	NSString *name;
	NSString *value;
}

@property(retain)NSString *name;
@property(retain)NSString *value;
-(id)initWithName:(NSString *)aName value:(NSString *)aValue;
-(NSString *)URLEncodedName;
-(NSString *)URLEncodedValue;
-(NSString *)URLEncodedNameValuePair;

@end
