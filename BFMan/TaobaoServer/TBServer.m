//
//  TBServer.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-20.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "TBServer.h"
#import "BFManConstants.h"
#import "ASIHTTPRequest.h"
#import "NSString+MD5.h"
#import "SBJsonParser.h"
#import "User.h"
#import "Item.h"
#import "ItemCat.h"
#import "TaobaokeItem.h"
#import "TradeRate.h"
#import "TaobaokeShop.h"
#import "Shop.h"
#import "CollectItem.h"
#import "HuaBao.h"
#import "HuabaoPicture.h"
#import "HuabaoAuctionInfo.h"
#import "NSString+Additions.h"

@implementation TBServer
@synthesize delegate = _delegate, api, needAuth, request = _request;

- (TBServer *)initWithDelegate:(id<TBServerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSData *responseData = [request responseData];
    
    if (api == TB_GETIMAGE) {
        [_delegate requestFinished:[UIImage imageWithData:responseData]];
        return;
    }
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *json = [parser objectWithString:[request responseString]];
    NSDictionary *error = [json objectForKey:@"error_response"];
    if (error != nil) {
        if ([error objectForKey:@"sub_msg"]) {
            [_delegate requestFailed:[error objectForKey:@"sub_msg"]];
        } else
            [_delegate requestFailed:[error objectForKey:@"msg"]];
    } else {
        switch (api) {
            case TB_API_GETUSER:
                [_delegate requestFinished:[User userFromResponse:json]];
                break;
            case TB_API_GETITEM:
                [_delegate requestFinished:[Item itemFromResponse:json]];
                break;
            case TB_API_GETITEM_DESC:
                [_delegate requestFinished:[Item itemDescFromResponse:json]];
                break;
            case TB_API_GETITEMCATS:
                [_delegate requestFinished:[ItemCat itemCatsFromResponse:json]];
                break;
            case TB_API_GETTBKITEMS:
                [_delegate requestFinished:[TaobaokeItem taobaokeItemsFromResponse:json]];
                break;
            case TB_API_CONVERTTBKITEMS:
                [_delegate requestFinished:[Item itemClickUrlFromResponse:json]];
                break;
            case TB_API_CHECKTBCITEM:
                [_delegate requestFinished:[TaobaokeItem taobaokeItemsFromConvertResponse:json]];
                break;
            case TB_API_CONVERTLISTOFITEMS:
                [_delegate requestFinished:[TaobaokeItem taobaokeItemsFromConvertResponse:json]];
                break;
            case TB_API_GETTRADERATES:
                [_delegate requestFinished:[TradeRate tradeRatesFromResponse:json]];
                break;
            case TB_API_GETTBKSHOPS:
                [_delegate requestFinished:[TaobaokeShop taobaokeShopsFromResponse:json]];
                break;
            case TB_API_GETSHOP:
                [_delegate requestFinished:[Shop shopFromResponse:json]];
                break;
            case TB_API_GETCOLLECTITEMS:
                [_delegate requestFinished:[CollectItem collectItemsFromResponse:json]];
                break;
            case TB_API_POSTERSGET:
                [_delegate requestFinished:[HuaBao huabaoListFromPosterGet:json]];
                break;
            case TB_API_POSTERSSEARCH:
                [_delegate requestFinished:[HuaBao huabaoListFromPosterSearch:json]];
                break;
            case TB_API_APPOINTEDPOSTERSGET:
                [_delegate requestFinished:[HuaBao huabaoListFromAppointedPosters:json]];
                break;
            case TB_API_POSTERDETAILGET:
                [_delegate requestFinished:[HuabaoPicture huabaoPicturesFromPosterDetail:json]];
                break;
            case TB_API_POSTAUCTIONSGET:
                [_delegate requestFinished:[HuabaoAuctionInfo hbAuctionInfosFromPostAuctions:json]];
                break;
            default:
                break;
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [_delegate requestFailed:ERROR_CANT_LOAD];
}

- (NSString *)sign:(NSDictionary *)params {
    NSArray *keyArray = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 localizedCaseInsensitiveCompare:(NSString *)obj2];
    }];
    NSMutableArray *strArr = [NSMutableArray arrayWithCapacity:[keyArray count] + 2];
    [strArr addObject:TAOBAO_APP_SECRET_STR];
    for (NSString *key in keyArray) {
        [strArr addObject:[NSString stringWithFormat:@"%@%@",key, [params objectForKey:key]]];
    }
    [strArr addObject:TAOBAO_APP_SECRET_STR];
    NSString *signStr = [strArr componentsJoinedByString:@""];
    return [[signStr md5] uppercaseString];
}

- (void)processMethod:(NSString *)method params:(NSMutableDictionary *)params {
    // add API method
    [params setValue:method forKey:@"method"];

    /*
    // add sesson key
    if (needAuth) {
        TBLoginServer *login = [TBLoginServer sharedServer];
        NSString *sessionKey = [login getSessionKey];
        [params setValue:sessionKey forKey:@"session"];
    }*/
    
    // add timestamp
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateStr = [formatter stringFromDate:now];
    
    [params setValue:dateStr forKey:@"timestamp"];
    
    // add format, always use json
    [params setValue:@"json" forKey:@"format"];
    
    // add appkey
    [params setValue:TAOBAO_APP_KEY_STR forKey:@"app_key"];
    
    // add api version
    [params setValue:@"2.0" forKey:@"v"];
    
    // add sign method
    [params setValue:@"md5" forKey:@"sign_method"];
    
    NSString *sign = [self sign:params];
    [params setValue:sign forKey:@"sign"];
    
    NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:[params count]];
    for (NSString *key in params) {
        [paramArray addObject:[NSString stringWithFormat:@"%@=%@", key, [[NSString stringWithFormat:@"%@", [params objectForKey:key]] URLEncodedString]]];
    }
    NSString *paramStr = [paramArray componentsJoinedByString:@"&"];
    NSString *urlStr = [NSString stringWithFormat:@"%@?%@", TAOBAO_API_ADDR, paramStr];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    
    self.request = [[ASIHTTPRequest alloc] initWithURL:url];
    [_request setDelegate:self];
    [_request startAsynchronous];
}

- (void)getUser {
    self.api = TB_API_GETUSER;
    self.needAuth = YES;
    NSString *fieldsStr = [[User fields] componentsJoinedByString:@","];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:fieldsStr forKey:@"fields"];
    [self processMethod:TOP_USER_GET params:params];
}

- (void)getItemCatsFor:(NSNumber *)cid {
    self.api = TB_API_GETITEMCATS;
    self.needAuth = NO;
    NSString *fieldsStr = [[ItemCat fields] componentsJoinedByString:@","];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:fieldsStr forKey:@"fields"];
    [params setValue:cid forKey:@"parent_cid"];
    [self processMethod:TOP_ITEMCATS_GET params:params];
}

- (void)getItemInfo:(NSNumber *)itemID {
    self.api = TB_API_GETITEM;
    self.needAuth = NO;
    NSString *fieldsStr = [[Item fields] componentsJoinedByString:@","];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:fieldsStr forKey:@"fields"];
    [params setValue:itemID forKey:@"num_iid"];
    [self processMethod:TOP_ITEM_GET params:params];
}

- (void)getItemDesc:(NSNumber *)itemID {
    self.api = TB_API_GETITEM_DESC;
    self.needAuth = NO;
    NSString *fieldsStr = @"desc";
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:fieldsStr forKey:@"fields"];
    [params setValue:itemID forKey:@"num_iid"];
    [self processMethod:TOP_ITEM_GET params:params];
}

- (void)getTaobaokeItems:(NSDictionary *)params {
    self.api = TB_API_GETTBKITEMS;
    self.needAuth = NO;
    NSString *fieldsStr = [[TaobaokeItem fields] componentsJoinedByString:@","];
    NSMutableDictionary *newParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    [newParams setValue:fieldsStr forKey:@"fields"];
    [newParams setValue:TAOBAOKE_PID forKey:@"pid"];
    [newParams setValue:@"true" forKey:@"is_mobile"];
    [newParams setValue:@"BFMan" forKey:@"outer_code"];
    [self processMethod:TOP_TBK_ITEMS_GET params:newParams];
}

- (void)convertTaobaokeItems:(NSNumber *)itemId {
    self.api = TB_API_CONVERTTBKITEMS;
    self.needAuth = NO;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:@"click_url" forKey:@"fields"];
    [params setValue:TAOBAOKE_PID_FOR_WEIBO forKey:@"pid"];
    [params setValue:itemId forKey:@"num_iids"];
    [params setValue:@"BFMan" forKey:@"outer_code"];
    [self processMethod:TOP_TBK_CONVERT_ITEM params:params];
}

- (void)convertListOfTBKItems:(NSArray *)items {
    self.api = TB_API_CONVERTLISTOFITEMS;
    self.needAuth = NO;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
    [params setValue:[[TaobaokeItem fields] componentsJoinedByString:@","] forKey:@"fields"];
    [params setValue:TAOBAOKE_PID forKey:@"pid"];
    [params setValue:[items componentsJoinedByString:@","] forKey:@"num_iids"];
    [params setValue:@"BFMan" forKey:@"outer_code"];
    [params setValue:@"true" forKey:@"is_mobile"];
    [self processMethod:TOP_TBK_CONVERT_ITEM params:params];
}

- (void)checkTaobaokeItem:(NSNumber *)itemId {
    self.api = TB_API_CHECKTBCITEM;
    self.needAuth = NO;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:4];
    [params setValue:[[TaobaokeItem fields] componentsJoinedByString:@","] forKey:@"fields"];
    [params setValue:TAOBAOKE_PID forKey:@"pid"];
    [params setValue:itemId forKey:@"num_iids"];
    [params setValue:@"true" forKey:@"is_mobile"];
    [self processMethod:TOP_TBK_CONVERT_ITEM params:params];
}

- (void)getTradeRateForItem:(Item *)item onPage:(NSInteger)page {
    self.api = TB_API_GETTRADERATES;
    self.needAuth = NO;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:item.itemID forKey:@"num_iid"];
    [params setValue:item.nick forKey:@"seller_nick"];
    [params setValue:[NSNumber numberWithInt:page] forKey:@"page_no"];
    [params setValue:[NSNumber numberWithInt:20] forKey:@"page_size"];
    
    [self processMethod:TOP_TRADERATES_SEARCH params:params];
}

- (void)getTaobaokeShops:(NSDictionary *)params {
    self.api = TB_API_GETTBKSHOPS;
    self.needAuth = NO;
    
    NSString *fieldsStr = [[TaobaokeShop fields] componentsJoinedByString:@","];
    NSMutableDictionary *newParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    [newParams setValue:fieldsStr forKey:@"fields"];
    [newParams setValue:TAOBAOKE_PID forKey:@"pid"];
    [self processMethod:TOP_TBK_SHOPS_GET params:newParams];
}

- (void)getShop:(NSString *)nick {
    self.api = TB_API_GETSHOP;
    self.needAuth = NO;
    
    NSString *fieldsStr = [[Shop fields] componentsJoinedByString:@","];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:fieldsStr forKey:@"fields"];
    [params setValue:nick forKey:@"nick"];
    [self processMethod:TOP_SHOP_GET params:params];
}

- (void)getCollectItems:(NSDictionary *)params {
    self.api = TB_API_GETCOLLECTITEMS;
    self.needAuth = YES;
    
    NSMutableDictionary *newParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    [newParams setValue:@"ITEM" forKey:@"collect_type"];
    [self processMethod:TOP_COLLECT_ITEM_GET params:newParams];
}

- (void)getPosters:(NSMutableDictionary *)params {
    self.api = TB_API_POSTERSGET;
    self.needAuth = NO;
    
    [self processMethod:TOP_POSTERS_GET params:params];
}

- (void)searchPosters:(NSMutableDictionary *)params {
    self.api = TB_API_POSTERSSEARCH;
    self.needAuth = NO;
    
    [self processMethod:TOP_POSTERS_SEARCH params:params];
}

- (void)getAppointedPosters:(NSMutableDictionary *)params {
    self.api = TB_API_APPOINTEDPOSTERSGET;
    self.needAuth = NO;
    
    [self processMethod:TOP_APPOINTED_POSTERS_GET params:params];
}

- (void)getPosterDetail:(NSNumber *)posterId {
    self.api = TB_API_POSTERDETAILGET;
    self.needAuth = NO;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:posterId forKey:@"poster_id"];
    [self processMethod:TOP_POSTER_DETAIL_GET params:params];
}

- (void)getPosterAuctionInfos:(NSNumber *)posterId {
    self.api = TB_API_POSTAUCTIONSGET;
    self.needAuth = NO;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:posterId forKey:@"poster_id"];
    [self processMethod:TOP_POSTER_AUCTIONS_GET params:params];
}

- (void)getImage:(NSString *)picUrl {
    self.api = TB_GETIMAGE;
    NSURL *url = [[NSURL alloc] initWithString:picUrl];
    self.request = [[ASIHTTPRequest alloc] initWithURL:url];
    _request.delegate = self;
    [_request startAsynchronous];
}

- (void)dealloc {
    [self.request clearDelegatesAndCancel];
}

@end
