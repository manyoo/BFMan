//
//  HuabaoPicture.m
//  BFMan
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "HuabaoPicture.h"
#import "NSString+HTML.h"

@implementation HuabaoPicture

@synthesize posterId, picId, createDate, modifiedDate, picUrl, picNote;

+ (HuabaoPicture *)huabaoPictureFromDictionary:(NSDictionary *)dict {
    HuabaoPicture *pic = [[HuabaoPicture alloc] init];
    
    pic.posterId = [dict objectForKey:@"poster_id"];
    pic.picId = [dict objectForKey:@"pic_id"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    pic.createDate = [formatter dateFromString:[dict objectForKey:@"create_date"]];
    pic.modifiedDate = [formatter dateFromString:[dict objectForKey:@"modified_date"]];
    pic.picUrl = [dict objectForKey:@"pic_url"];
    pic.picNote = [[dict objectForKey:@"pic_note"] stringByDecodingHTMLEntities];
    
    return pic;
}

+ (NSArray *)huabaoPicturesFromArray:(NSArray *)arr {
    NSMutableArray *pics = [[NSMutableArray alloc] initWithCapacity:[arr count]];
    
    for (NSDictionary *dict in arr) {
        [pics addObject:[HuabaoPicture huabaoPictureFromDictionary:dict]];
    }
    
    return pics;
}

+ (NSArray *)huabaoPicturesFromPosterDetail:(NSDictionary *)resp {
    NSArray *pics = [[[resp objectForKey:@"poster_posterdetail_get_response"] objectForKey:@"poster_pics"] objectForKey:@"huabao_picture"];
    return [HuabaoPicture huabaoPicturesFromArray:pics];
}

@end
