//
//  Shop.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-25.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Shop : NSManagedObject

@property (nonatomic, retain) NSNumber * sid;          // 店铺编号
@property (nonatomic, retain) NSNumber * cid;          // 店铺类目编号
@property (nonatomic, retain) NSString * nick;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;         // 店铺描述
@property (nonatomic, retain) NSString * bulletin;     // 店铺公告
@property (nonatomic, retain) NSString * picUrl;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSManagedObject *shopScore;

+ (NSArray *)fields;
+ (Shop *)shopFromResponse:(NSDictionary *)resp;

@end
