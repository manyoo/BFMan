//
//  Token.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Token : NSObject {
	NSString *key;
	NSString *secret;
	NSString *pin;
}

@property(retain)NSString *key;
@property(retain)NSString *secret;
@property(retain)NSString *pin;

- (id)initWithHTTPResponseBody:(NSString *)body;

@end
