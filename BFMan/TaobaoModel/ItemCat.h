//
//  ItemCat.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CAT_STATUS_NORMAL,
    CAT_STATUS_DELETED
} CatStatus;

@interface ItemCat : NSObject
@property (nonatomic, strong) NSNumber *cid;    //类目ID
@property (nonatomic, strong) NSNumber *parentCid; // 父类目ID，=0时为一级类目
@property (nonatomic, strong) NSString *name;
@property (nonatomic) BOOL isParent;
@property (nonatomic) CatStatus status;
@property (nonatomic, strong) NSNumber *sortOrder; //同一层类目中的顺序号

@property (nonatomic, strong) NSMutableArray *subCategories;

+ (NSArray *)itemCatsFromResponse:(NSDictionary *)respDict;
+ (NSArray *)fields;

- (void)addSubCategory:(ItemCat *)subCat;
- (NSString *)getSubCategoryNames;

@end
