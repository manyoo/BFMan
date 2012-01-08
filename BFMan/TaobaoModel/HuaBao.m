//
//  HuaBao.m
//  BFMan
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "HuaBao.h"

@implementation HuaBao

@synthesize huabaoID, channelId, modifiedDate, title, titleShort, tag, weight, coverPicUrl, hits, createDate;

+ (HuaBao *)huabaoFromDictionary:(NSDictionary *)dict {
    HuaBao *huabao = [[HuaBao alloc] init];
    
    huabao.huabaoID = [dict objectForKey:@"id"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    huabao.createDate = [formatter dateFromString:[dict objectForKey:@"create_date"]];
    huabao.modifiedDate = [formatter dateFromString:[dict objectForKey:@"modified_date"]];
    huabao.title = [dict objectForKey:@"title"];
    huabao.titleShort = [dict objectForKey:@"title_short"];
    huabao.tag = [dict objectForKey:@"tag"];
    huabao.weight = [dict objectForKey:@"weight"];
    huabao.coverPicUrl = [dict objectForKey:@"cover_pic_url"];
    huabao.hits = [dict objectForKey:@"hits"];
    huabao.channelId = [dict objectForKey:@"channel_id"];
    
    return huabao;
}

+ (NSArray *)huabaoListFromResponse:(NSDictionary *)resp {
    
}

@end
