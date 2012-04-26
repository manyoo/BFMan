//
//  HuabaoAuctionInfo.m
//  BFMan
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "HuabaoAuctionInfo.h"
#import "NSString+HTML.h"

@implementation HuabaoAuctionInfo

@synthesize auctionId, posterId, auctionTitle, auctionShortTitle, auctionPrice, auctionNote, auctionUrl, picId, auctionPosition, tbkItem;

+ (HuabaoAuctionInfo *)hbAuctionInfoFromDict:(NSDictionary *)dict {
    HuabaoAuctionInfo *hbInfo = [[HuabaoAuctionInfo alloc] init];
    
    hbInfo.auctionId = [dict objectForKey:@"auction_id"];
    hbInfo.posterId = [dict objectForKey:@"poster_id"];
    hbInfo.auctionTitle = [[dict objectForKey:@"auction_title"] stringByDecodingHTMLEntities];
    hbInfo.auctionShortTitle = [[dict objectForKey:@"auction_short_title"] stringByDecodingHTMLEntities];
    hbInfo.auctionPrice = [NSNumber numberWithFloat:[[dict objectForKey:@"auction_price"] floatValue]];
    hbInfo.auctionNote = [[dict objectForKey:@"auction_note"] stringByDecodingHTMLEntities];
    hbInfo.auctionUrl = [dict objectForKey:@"auction_url"];
    hbInfo.picId = [dict objectForKey:@"pic_id"];
    hbInfo.auctionPosition = [dict objectForKey:@"auction_position"];
    hbInfo.tbkItem = nil;
    
    return hbInfo;
}

+ (NSArray *)hbAuctionInfosFromArray:(NSArray *)arr {
    NSMutableArray *auctions = [[NSMutableArray alloc] initWithCapacity:[arr count]];
    
    for (NSDictionary *dict in arr) {
        [auctions addObject:[HuabaoAuctionInfo hbAuctionInfoFromDict:dict]];
    }
    
    return auctions;
}

+ (NSArray *)hbAuctionInfosFromPostAuctions:(NSDictionary *)resp {
    NSArray *auctions = [[[resp objectForKey:@"poster_postauctions_get_response"] objectForKey:@"posterauctions"] objectForKey:@"huabao_auction_info"];
    return [HuabaoAuctionInfo hbAuctionInfosFromArray:auctions];
}
@end
