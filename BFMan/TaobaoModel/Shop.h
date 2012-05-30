//
//  Shop.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-25.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Shop : NSObject

@property (nonatomic, strong) NSNumber * sid;          // 店铺编号
@property (nonatomic, strong) NSNumber * cid;          // 店铺类目编号
@property (nonatomic, strong) NSString * nick;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * desc;         // 店铺描述
@property (nonatomic, strong) NSString * bulletin;     // 店铺公告
@property (nonatomic, strong) NSString * picUrl;
@property (nonatomic, strong) NSDate * created;
@property (nonatomic, strong) NSDate * modified;
@property (nonatomic, strong) NSManagedObject *shopScore;

+ (NSArray *)fields;
+ (Shop *)shopFromResponse:(NSDictionary *)resp;

@end
