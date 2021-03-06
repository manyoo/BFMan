//
//  HuaBao.h
//  BFMan
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemImg;

@interface HuaBao : NSObject

@property (nonatomic, strong) NSNumber *huabaoID;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifiedDate;
@property (nonatomic, strong) NSString *title;        // 画报标题
@property (nonatomic, strong) NSString *titleShort;   // 画报短标题
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSNumber *weight;       // 画报权重 0 - 10
@property (nonatomic, strong) NSString *coverPicUrl;
@property (nonatomic, strong) NSNumber *hits;         // 画报点击数
@property (nonatomic, strong) NSNumber *channelId;
@property (nonatomic, strong) ItemImg *itemImg;

+ (HuaBao *)huabaoFromDictionary:(NSDictionary *)dict;
+ (NSArray *)huabaoListFromResponse:(NSArray *)resp;
+ (NSArray *)huabaoListFromPosterGet:(NSDictionary *)resp;
+ (NSArray *)huabaoListFromPosterSearch:(NSDictionary *)resp;
+ (NSArray *)huabaoListFromAppointedPosters:(NSDictionary *)resp;

@end
