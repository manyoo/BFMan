//
//  CollectItem.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-26.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaobaokeItem;

@interface CollectItem : NSObject

@property (nonatomic, strong) NSString *itemOwnerNick;
@property (nonatomic, strong) NSNumber *itemNumId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) TaobaokeItem *tbkItem;

+ (NSDictionary *)collectItemsFromResponse:(NSDictionary *)resp;

@end
