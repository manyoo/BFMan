//
//  NSString+URLConvert.m
//  BFMan
//
//  Created by  on 12-4-25.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "NSString+URLConvert.h"
#import "BFManConstants.h"

@implementation NSString (URLConvert)

- (NSString *)newClickUrlForItemId:(NSNumber *)itemId {
    NSURL *url = [NSURL URLWithString:self];
    NSString *paramStr = url.query;
    
    NSArray *paramsArr = [paramStr componentsSeparatedByString:@"&"];
    NSString *tks = nil;
    for (NSString *p in paramsArr) {
        NSArray *pa = [p componentsSeparatedByString:@"="];
        if ([[pa objectAtIndex:0] isEqualToString:@"tks"]) {
            tks = [pa objectAtIndex:1];
        }
    }
    if (tks == nil) {
        return nil;
    }
    return [NSString stringWithFormat:@"http://a.m.taobao.com/i%@.htm?tks=%@&ttid=%@", itemId, tks, TAOBAO_TTID_STR];
}

@end
