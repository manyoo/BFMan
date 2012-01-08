//
//  Emotion.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-24.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+GetValue.h"

@interface Emotion : NSObject {

	NSString *phrase;
	NSString *type;
	NSString *url;
	BOOL is_hot;
	int order_number;
	NSString *category;
}

@property (nonatomic,retain)NSString *phrase;
@property (nonatomic,retain)NSString *type;
@property (nonatomic,retain)NSString *url;
@property (nonatomic,assign)BOOL is_hot;
@property (nonatomic,assign)int order_number;
@property (nonatomic,retain)NSString *category;

-(id)initWithJson:(NSDictionary*)dic;

@end
