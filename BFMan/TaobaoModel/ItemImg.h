//
//  ItemImg.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ItemImg : NSObject
@property (nonatomic, strong) NSNumber * imgId;
@property (nonatomic, strong) NSNumber * position;
@property (nonatomic, strong) NSString * url;

+ (NSArray *)itemImgsFromResponse:(NSDictionary *)respDict;

@end
