//
//  HuabaoAuctionInfo.h
//  BFMan
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaobaokeItem;

@interface HuabaoAuctionInfo : NSObject

@property (nonatomic, strong) NSNumber *auctionId;
@property (nonatomic, strong) NSNumber *posterId;
@property (nonatomic, strong) NSString *auctionTitle;
@property (nonatomic, strong) NSString *auctionShortTitle;
@property (nonatomic, strong) NSNumber *auctionPrice;
@property (nonatomic, strong) NSString *auctionNote;
@property (nonatomic, strong) NSString *auctionUrl;
@property (nonatomic, strong) NSNumber *picId;
@property (nonatomic, strong) NSString *auctionPosition;

@property (nonatomic, strong) TaobaokeItem *tbkItem;

+ (HuabaoAuctionInfo *)hbAuctionInfoFromDict:(NSDictionary *)dict;
+ (NSArray *)hbAuctionInfosFromArray:(NSArray *)arr;
+ (NSArray *)hbAuctionInfosFromPostAuctions:(NSDictionary *)resp;

@end
