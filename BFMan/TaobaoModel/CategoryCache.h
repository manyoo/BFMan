//
//  CategoryCache.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-24.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaobaokeItem;

@interface CategoryCache : NSManagedObject
@property (nonatomic, retain) NSNumber * pagesNum;
@property (nonatomic, retain) NSString * sortMethod;

@property (nonatomic, retain) NSSet *items;
@end

@interface CategoryCache (CoreDataGeneratedAccessors)

- (void)addItemsObject:(TaobaokeItem *)value;
- (void)removeItemsObject:(TaobaokeItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;
@end
