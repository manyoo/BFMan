//
//  ItemCat.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "ItemCat.h"

NSArray *item_cat_fields = nil;

@implementation ItemCat
@synthesize cid, parentCid, name, isParent, status, sortOrder;
@synthesize subCategories;

+ (NSArray *)fields {
    if (item_cat_fields == nil) {
        item_cat_fields = [[NSArray alloc] initWithObjects:@"cid", @"parent_cid", @"name", @"is_parent", @"status", @"sort_order", nil];
    }
    return item_cat_fields;
}

+ (ItemCat *)itemCatFromDictionary:(NSDictionary *)dict {
    ItemCat *cat = [[ItemCat alloc] init];
    
    cat.cid = [dict objectForKey:@"cid"];
    cat.parentCid = [dict objectForKey:@"parent_cid"];
    cat.name = [dict objectForKey:@"name"];
    cat.isParent = [[dict objectForKey:@"is_parent"] boolValue];
    
    if ([[dict objectForKey:@"status"] isEqualToString:@"normal"]) {
        cat.status = CAT_STATUS_NORMAL;
    } else
        cat.status = CAT_STATUS_DELETED;
    
    cat.sortOrder = [dict objectForKey:@"sort_order"];
    
    return cat;
}

+ (NSArray *)itemCatsFromResponse:(NSDictionary *)respDict {
    NSDictionary *catsResp = [respDict objectForKey:@"itemcats_get_response"];
    NSDictionary *item_cats = [catsResp objectForKey:@"item_cats"];
    NSArray *itemCatsArray = [item_cats objectForKey:@"item_cat"];

    NSMutableArray *itemCats = [[NSMutableArray alloc] initWithCapacity:[itemCatsArray count]];
    for (NSDictionary *dict in itemCatsArray) {
        [itemCats addObject:[ItemCat itemCatFromDictionary:dict]];
    }
    return itemCats;
}

- (void)addSubCategory:(ItemCat *)subCat {
    if (subCategories == nil) {
        self.subCategories = [[NSMutableArray alloc] init];
    }
    [subCategories addObject:subCat];
}

- (NSString *)getSubCategoryNames {
    NSMutableArray *names = [[NSMutableArray alloc] initWithCapacity:[subCategories count]];
    
    for (ItemCat *ic in subCategories) {
        [names addObject:ic.name];
    }
    return [names componentsJoinedByString:@"，"];
}

@end
