//
//  TBServer.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-20.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TBServerDelegate <NSObject>

- (void)requestFinished:(id)data;
- (void)requestFailed:(NSString *)msg;

@end

typedef enum {
    TB_API_GETUSER,
    TB_API_GETITEMCATS,
    TB_API_GETITEM,
    TB_API_GETLISTITEM,
    TB_API_GETITEM_DESC,
    TB_API_GETTBKITEMS,
    TB_API_CONVERTTBKITEMS,
    TB_API_CONVERTLISTOFITEMS,
    TB_API_GETTRADERATES,
    TB_API_GETTBKSHOPS,
    TB_API_GETSHOP,
    TB_API_GETCOLLECTITEMS,
    TB_API_CHECKTBCITEM,
    TB_API_POSTERSGET,
    TB_API_POSTERSSEARCH,
    TB_API_APPOINTEDPOSTERSGET,
    TB_API_POSTERDETAILGET,
    TB_API_POSTAUCTIONSGET,
    TB_GETIMAGE
} TBAPI;

@class Item;
@class ASIHTTPRequest;

@interface TBServer : NSObject
@property (nonatomic, unsafe_unretained) id<TBServerDelegate> delegate;
@property (nonatomic) TBAPI api;
@property (nonatomic) BOOL needAuth;
@property (nonatomic, strong) ASIHTTPRequest *request;

- (TBServer *)initWithDelegate:(id<TBServerDelegate>)delegate;

- (void)getUser;                            // get the current user info
- (void)getItemCatsFor:(NSNumber *)cid;                        // get all taobao categories
- (void)getItemInfo:(NSNumber *)itemID;
- (void)getListItems:(NSArray *)itemIds;
- (void)getItemDesc:(NSNumber *)itemID;
- (void)getTaobaokeItems:(NSDictionary *)params;
- (void)convertTaobaokeItems:(NSNumber *)itemId;
- (void)convertListOfTBKItems:(NSArray *)items;
- (void)getTradeRateForItem:(Item *)item onPage:(NSInteger)page;
- (void)getTaobaokeShops:(NSDictionary *)params;
- (void)getShop:(NSString *)nick;
- (void)getCollectItems:(NSDictionary *)params;
- (void)checkTaobaokeItem:(NSNumber *)itemId;
- (void)getPosters:(NSMutableDictionary *)params;
- (void)searchPosters:(NSMutableDictionary *)params;
- (void)getAppointedPosters:(NSMutableDictionary *)params;
- (void)getPosterDetail:(NSNumber *)posterId;
- (void)getPosterAuctionInfos:(NSNumber *)posterId;
- (void)getImage:(NSString *)picUrl;

@end
