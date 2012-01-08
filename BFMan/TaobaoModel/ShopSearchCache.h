//
//  ShopSearchCache.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-26.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaobaokeShop;

@interface ShopSearchCache : NSManagedObject

@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSNumber * pagesNum;
@property (nonatomic, retain) NSSet *shops;
@end

@interface ShopSearchCache (CoreDataGeneratedAccessors)

- (void)addShopsObject:(TaobaokeShop *)value;
- (void)removeShopsObject:(TaobaokeShop *)value;
- (void)addShops:(NSSet *)values;
- (void)removeShops:(NSSet *)values;
@end
