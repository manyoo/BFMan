//
//  GlobalFunc.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-28.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalFunc : NSObject

CGRect ApplicationFrame(UIInterfaceOrientation interfaceOrientation);

time_t convertTimeStamp(NSString *stringTime);

@end
