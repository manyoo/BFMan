//
//  ItemImg.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ItemImg : NSManagedObject
@property (nonatomic, retain) NSNumber * imgId;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSString * url;

+ (NSArray *)itemImgsFromResponse:(NSDictionary *)respDict;

@end
