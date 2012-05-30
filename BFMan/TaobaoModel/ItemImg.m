//
//  ItemImg.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "ItemImg.h"

@implementation ItemImg
@synthesize imgId, url, position;

+ (ItemImg *)itemImgFromDictionary:(NSDictionary *)dict {    
    ItemImg *img = [[ItemImg alloc] init];
    
    img.imgId = [dict objectForKey:@"img_id"];
    img.url = [dict objectForKey:@"url"];
    img.position = [dict objectForKey:@"position"];
    
    return img;
}

+ (NSArray *)itemImgsFromResponse:(NSDictionary *)respDict {
    NSArray *itemImgsArray = [respDict objectForKey:@"item_img"];
    
    NSMutableArray *itemImgs = [[NSMutableArray alloc] initWithCapacity:[itemImgsArray count]];
    for (NSDictionary *dict in itemImgsArray) {
        [itemImgs addObject:[ItemImg itemImgFromDictionary:dict]];
    }
    return itemImgs;
}

@end
