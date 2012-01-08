//
//  RFC1867.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-5-8.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RFC1867 : NSObject {
	NSString *FORM_BOUNDARY;
}

@property(nonatomic,retain)NSString *FORM_BOUNDARY;

-(NSString *)nameValString:(NSDictionary *)dic;
-(NSMutableData *)getMultipartFormData:(NSDictionary *)dic data:(NSData*)aData name:(NSString *)aName filename:(NSString *)aFilename contentType:(NSString *)aContentType;
@end
