//
//  TBHelper.h
//  SmartTao
//
//  Created by  on 12-3-19.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBServer.h"

@class Shop;

@protocol TBHelperDelegate <NSObject>

- (void)helperFinishedWith:(id)obj;
- (void)helperFailed:(NSString *)msg;

@end

@interface TBHelper : NSObject<TBServerDelegate>

@property (nonatomic, strong) TBServer *server;
@property (nonatomic) TBAPI apiType;
@property (nonatomic, unsafe_unretained) id<TBHelperDelegate> delegate;

@property (nonatomic, strong) NSArray *itemIDs;
@property (nonatomic, strong) NSMutableDictionary *itemWrappers;

- (id)init;

- (void)getTaobaokeItemsForItems:(NSArray *)itemids;

@end
