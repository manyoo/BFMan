//
//  ItemWrapper.h
//  SmartTao
//
//  Created by  on 12-3-13.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaobaokeItem;
@class Item;

@interface ItemWrapper : NSObject

@property (nonatomic, strong) NSString *itemOwnerNick;
@property (nonatomic, strong) NSNumber *itemId;
@property (nonatomic, strong) NSNumber *realPrice;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) TaobaokeItem *tbkItem;
@property (nonatomic, strong) Item *item;

@end
