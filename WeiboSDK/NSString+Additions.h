//
//  NSString+URLEncoding.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-27.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Additions)

-(NSString *)URLEncodedString;
-(NSString *)URLDecodedString;
-(NSString*)encodeAsURIComponent;
@end
