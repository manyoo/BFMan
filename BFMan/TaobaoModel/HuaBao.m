//
//  HuaBao.m
//  BFMan
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "HuaBao.h"
#import "NSString+HTML.h"

@implementation HuaBao

@synthesize huabaoID, channelId, modifiedDate, title, titleShort, tag, weight, coverPicUrl, hits, createDate, itemImg;

+ (HuaBao *)huabaoFromDictionary:(NSDictionary *)dict {
    HuaBao *huabao = [[HuaBao alloc] init];
    
    huabao.huabaoID = [dict objectForKey:@"id"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    huabao.createDate = [formatter dateFromString:[dict objectForKey:@"create_date"]];
    huabao.modifiedDate = [formatter dateFromString:[dict objectForKey:@"modified_date"]];
    huabao.title = [[dict objectForKey:@"title"] stringByDecodingHTMLEntities];
    huabao.titleShort = [[dict objectForKey:@"title_short"] stringByDecodingHTMLEntities];
    huabao.tag = [dict objectForKey:@"tag"];
    huabao.weight = [dict objectForKey:@"weight"];
    huabao.coverPicUrl = [dict objectForKey:@"cover_pic_url"];
    huabao.hits = [dict objectForKey:@"hits"];
    huabao.channelId = [dict objectForKey:@"channel_id"];
    huabao.itemImg = nil;
    
    return huabao;
}

+ (NSArray *)huabaoListFromResponse:(NSArray *)resp {
    NSMutableArray *hblist = [[NSMutableArray alloc] initWithCapacity:[resp count]];
    
    for (NSDictionary *dict in resp) {
        [hblist addObject:[HuaBao huabaoFromDictionary:dict]];
    }
    
    return hblist;
}

+ (NSArray *)huabaoListFromPosterGet:(NSDictionary *)resp {
    NSArray *posters = [[[resp objectForKey:@"poster_posters_get_response"] objectForKey:@"posters"] objectForKey:@"huabao"];
    return [HuaBao huabaoListFromResponse:posters];
}

+ (NSArray *)huabaoListFromPosterSearch:(NSDictionary *)resp {
    NSArray *posters = [[[resp objectForKey:@"poster_posters_search_response"] objectForKey:@"posters"] objectForKey:@"huabao"];
    return [HuaBao huabaoListFromResponse:posters];
}

+ (NSArray *)huabaoListFromAppointedPosters:(NSDictionary *)resp {
    NSArray *posters = [[[resp objectForKey:@"poster_appointedposters_get_response"] objectForKey:@"appointedposters"] objectForKey:@"huabao"];
    return [HuaBao huabaoListFromResponse:posters];
}

@end
