//
//  NSDictionary+GetValue.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-5.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (GetValueAdditions)

-(BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
-(int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;
-(time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;
-(long long)getLongLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue;
-(NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

@end
