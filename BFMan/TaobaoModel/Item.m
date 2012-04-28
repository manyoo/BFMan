//
//  Item.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "Item.h"
#import "Location.h"
#import "ItemImg.h"

NSArray *item_fields = nil;

@implementation Item

@synthesize itemID, title, nick, type, detailUrl, desc, propsName, created, isLightningConsignment, cid, props, picUrl, num, validThru, 
listTime, delistTime, stuffStatus, location, price, postFee, expressFee, emsFee, hasDiscount, freightPayer, hasInvoice, 
hasWarranty, itemImgs, isVirtual, isTaobao, violation, sellPromise;

+ (NSArray *)fields {
    if (item_fields == nil) {
        item_fields = [[NSArray alloc] initWithObjects:@"num_iid", @"title", @"nick", @"detail_url", @"type", @"props_name", @"created",
                       @"is_lightning_consignment", @"cid", @"props", @"pic_url", @"num", @"valid_thru", @"list_time",
                       @"delist_time", @"stuff_status", @"location", @"price", @"post_fee", @"express_fee", @"ems_fee", 
                       @"has_discount", @"freight_payer", @"has_invoice", @"has_warranty", @"item_img", 
                       @"is_virtual", @"is_taobao", @"violation", @"sell_promise", nil];
    }
    return item_fields;
}

+ (Item *)itemFromDict:(NSDictionary *)itemDict {
    Item *item = [[Item alloc] init];
    
    item.itemID = [itemDict objectForKey:@"num_iid"];
    item.title = [itemDict objectForKey:@"title"];
    item.nick = [itemDict objectForKey:@"nick"];
    item.type = [itemDict objectForKey:@"type"];
    item.detailUrl = [itemDict objectForKey:@"detail_url"];
    item.propsName = [itemDict objectForKey:@"props_name"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    item.created = [formatter dateFromString:[itemDict objectForKey:@"created"]];
    
    item.isLightningConsignment = [[itemDict objectForKey:@"is_lightning_consignment"] boolValue];
    item.cid = [itemDict objectForKey:@"cid"];
    item.props = [itemDict objectForKey:@"props"];
    item.picUrl = [itemDict objectForKey:@"pic_url"];
    item.num = [itemDict objectForKey:@"num"];
    item.validThru = [itemDict objectForKey:@"valid_thru"];
    item.listTime = [formatter dateFromString:[itemDict objectForKey:@"list_time"]];
    item.delistTime = [formatter dateFromString:[itemDict objectForKey:@"delist_time"]];
    
    NSString *stuffStatusStr = [itemDict objectForKey:@"stuff_status"];
    if ([stuffStatusStr isEqualToString:@"new"]) {
        item.stuffStatus = STUFF_NEW;
    } else if ([stuffStatusStr isEqualToString:@"unused"]) {
        item.stuffStatus = STUFF_UNUSED;
    } else 
        item.stuffStatus = STUFF_SECOND;
    
    item.location = [Location locationFromResponse:[itemDict objectForKey:@"location"]];
    item.price = [NSNumber numberWithFloat:[[itemDict objectForKey:@"price"] floatValue]];
    item.postFee = [NSNumber numberWithFloat:[[itemDict objectForKey:@"post_fee"] floatValue]];
    item.expressFee = [NSNumber numberWithFloat:[[itemDict objectForKey:@"express_fee"] floatValue]];
    item.emsFee = [NSNumber numberWithFloat:[[itemDict objectForKey:@"ems_fee"] floatValue]];
    item.hasDiscount = [[itemDict objectForKey:@"has_discount"] boolValue];
    
    if ([[itemDict objectForKey:@"freight_payer"] isEqualToString:@"buyer"]) {
        item.freightPayer = FREIGHT_BUYER;
    } else
        item.freightPayer = FREIGHT_SELLER;
    
    item.hasInvoice = [[itemDict objectForKey:@"has_invoice"] boolValue];
    item.hasWarranty = [[itemDict objectForKey:@"has_warranty"] boolValue];
    item.itemImgs = [ItemImg itemImgsFromResponse:[itemDict objectForKey:@"item_imgs"]];
    item.isVirtual = [[itemDict objectForKey:@"is_virtual"] boolValue];
    item.isTaobao = [[itemDict objectForKey:@"is_taobao"] boolValue];
    item.violation = [[itemDict objectForKey:@"violation"] boolValue];
    item.sellPromise = [[itemDict objectForKey:@"sell_promise"] boolValue];
    
    return item;
}

+ (Item *)itemFromResponse:(NSDictionary *)respDict {
    NSDictionary *itemResp = [respDict objectForKey:@"item_get_response"];
    NSDictionary *itemDict = [itemResp objectForKey:@"item"];
    return [Item itemFromDict:itemDict];
}

+ (NSString *)itemDescFromResponse:(NSDictionary *)respDict {
    if (respDict == nil) {
        return nil;
    }
    NSDictionary *itemResp = [respDict objectForKey:@"item_get_response"];
    NSDictionary *itemDict = [itemResp objectForKey:@"item"];
    
    return [itemDict objectForKey:@"desc"];
}

+ (NSString *)itemClickUrlFromResponse:(NSDictionary *)respDict {
    if (respDict == nil) {
        return nil;
    }
    NSDictionary *itemResp = [respDict objectForKey:@"taobaoke_items_convert_response"];
    NSDictionary *itemTBK = [itemResp objectForKey:@"taobaoke_items"];
    NSArray *items = [itemTBK objectForKey:@"taobaoke_item"];
    int totalResults = [[itemResp objectForKey:@"total_results"] intValue];
    if (totalResults == 1) {
        NSDictionary *item = [items objectAtIndex:0];
        return [item objectForKey:@"click_url"];
    }
    return nil;
}

+ (NSArray *)itemsFromGetListItemResponse:(NSMutableDictionary *)respDict {
    NSDictionary *itemResp = [respDict objectForKey:@"items_list_get_response"];
    NSArray *respArr = [[itemResp objectForKey:@"items"] objectForKey:@"item"];
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:respArr.count];
    
    for (NSDictionary *dic in respArr) {
        [items addObject:[Item itemFromDict:dic]];
    }
    return items;
}

@end
