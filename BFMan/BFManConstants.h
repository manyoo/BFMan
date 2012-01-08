//
//  BFManConstants.h
//  BFMan
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#ifndef BFMan_BFManConstants_h
#define BFMan_BFManConstants_h

#include <Foundation/Foundation.h>

#ifdef BFMAN_DEFINED
#define _EXTERN
#define _INITIALIZE_AS(x) =x
#else
#define _EXTERN extern
#define _INITIALIZE_AS(x)
#endif

// app key for Sina Weibo
// TODO: change to new Weibo APP key and secret.
_EXTERN NSString *const SINA_WEIBO_APP_KEY_STR      _INITIALIZE_AS(@"1926133895");
_EXTERN NSString *const SINA_WEIBO_APP_SECRET_STR   _INITIALIZE_AS(@"8d0ccb3a9af46ee4cd0cfbc49b9ed3d2");


_EXTERN NSString *const TAOBAO_APP_KEY_STR          _INITIALIZE_AS(@"12359494");
_EXTERN NSString *const TAOBAO_APP_SECRET_STR       _INITIALIZE_AS(@"ca3a4127a4d902ff77491e89432d1464");

_EXTERN NSString *const TAOBAO_API_ADDR             _INITIALIZE_AS(@"http://gw.api.taobao.com/router/rest");


// used TOP APIs
_EXTERN NSString *const TOP_USER_GET                _INITIALIZE_AS(@"taobao.user.get");
_EXTERN NSString *const TOP_ITEMCATS_GET            _INITIALIZE_AS(@"taobao.itemcats.get");
_EXTERN NSString *const TOP_ITEM_GET                _INITIALIZE_AS(@"taobao.item.get");
_EXTERN NSString *const TOP_TBK_ITEMS_GET           _INITIALIZE_AS(@"taobao.taobaoke.items.get");
_EXTERN NSString *const TOP_TBK_CONVERT_ITEM        _INITIALIZE_AS(@"taobao.taobaoke.items.convert");
_EXTERN NSString *const TOP_TBK_REPORT_GET          _INITIALIZE_AS(@"taobao.taobaoke.report.get");
_EXTERN NSString *const TOP_TRADERATES_SEARCH       _INITIALIZE_AS(@"taobao.traderates.search");
_EXTERN NSString *const TOP_TBK_SHOPS_GET           _INITIALIZE_AS(@"taobao.taobaoke.shops.get");
_EXTERN NSString *const TOP_SHOP_GET                _INITIALIZE_AS(@"taobao.shop.get");
_EXTERN NSString *const TOP_COLLECT_ITEM_GET        _INITIALIZE_AS(@"taobao.favorite.search");

// 自己的pid，用于获取佣金
_EXTERN NSString *const TAOBAOKE_PID                _INITIALIZE_AS(@"28971285");
_EXTERN NSString *const TAOBAOKE_PID_FOR_WEIBO      _INITIALIZE_AS(@"29603941");

// 错误信息
_EXTERN NSString *const ALERT_TITLE_NOTIFY          _INITIALIZE_AS(@"提示");
_EXTERN NSString *const ERROR_CANT_LOAD             _INITIALIZE_AS(@"哦哦，出问题啦，先检查一下网络，或者稍后再试试吧。:(");


#endif
