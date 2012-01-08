//
//  Counts.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-22.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+GetValue.h"

@interface Counts : NSObject {
	long long statusId;
	long long comments;
	long long rt;
}

@property (nonatomic ,assign)long long statusId;
@property (nonatomic ,assign)long long comments;
@property (nonatomic,assign)long long rt;

-(Counts *)initWithJson:(NSDictionary*)dic;

@end
