//
//  HuabaoPicture.h
//  BFMan
//
//  Created by  on 12-1-8.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HuabaoPicture : NSObject

@property (nonatomic, strong) NSNumber *posterId;
@property (nonatomic, strong) NSString *picId;
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *modifiedDate;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, strong) NSString *picNote;

@end
