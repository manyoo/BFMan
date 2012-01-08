//
//  Item.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    STUFF_NEW,      //全新
    STUFF_UNUSED,   //闲置
    STUFF_SECOND    //二手
} StuffStatus;

typedef enum {
    FREIGHT_BUYER,
    FREIGHT_SELLER
} FreightPayer;

@class Location;

@interface Item : NSObject

@property (nonatomic, strong) NSNumber *itemID;    //num_iid
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *nick;      //卖家昵称
@property (nonatomic, strong) NSString *type;      // fixed:一口价 auction:拍卖
@property (nonatomic, strong) NSString *detailUrl; // 商品页面地址
@property (nonatomic, strong) NSString *desc;      // 商品详细信息
@property (nonatomic, strong) NSString *propsName; // 商品属性名称，详见淘宝文档
                                                   // http://api.taobao.com/apidoc/dataStruct.htm?path=dataStructId:63-apiId:20
@property (nonatomic, strong) NSDate *created;     // 商品发布时间
@property (nonatomic) BOOL isLightningConsignment; // 是否24小时闪电发货
@property (nonatomic, strong) NSNumber *cid;       //叶子类目ID
@property (nonatomic, strong) NSString *props;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSNumber *num;       // 商品数量
@property (nonatomic, strong) NSNumber *validThru; // 有效期
@property (nonatomic, strong) NSDate *listTime;    // 上架时间
@property (nonatomic, strong) NSDate *delistTime;  // 下架时间
@property (nonatomic) StuffStatus stuffStatus;
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *postFee;
@property (nonatomic, strong) NSNumber *expressFee;
@property (nonatomic, strong) NSNumber *emsFee;
@property (nonatomic) BOOL hasDiscount;             //支持会员打折
@property (nonatomic) FreightPayer freightPayer;    //运费承担方式
@property (nonatomic) BOOL hasInvoice;              //是否有发票
@property (nonatomic) BOOL hasWarranty;             //是否有保修
@property (nonatomic, strong) NSArray *itemImgs;
@property (nonatomic) BOOL isVirtual;
@property (nonatomic) BOOL isTaobao;                //是否在淘宝显示
@property (nonatomic) BOOL violation;               //是否违规
@property (nonatomic) BOOL sellPromise;             //是否承诺退换货

+ (Item *)itemFromResponse:(NSDictionary *)respDict;
+ (NSArray *)fields;
+ (NSString *)itemDescFromResponse:(NSDictionary *)respDict;
+ (NSString *)itemClickUrlFromResponse:(NSDictionary *)respDict;

@end
