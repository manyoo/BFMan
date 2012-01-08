//
//  Consumer.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Consumer : NSObject {
	NSString *key;
	NSString *secret;
}

@property(retain)NSString *key;
@property(retain)NSString *secret;

-(id)initWithKey:(NSString *)aKey secret:(NSString *)aSecret;

@end
