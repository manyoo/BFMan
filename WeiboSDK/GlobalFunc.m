//
//  GlobalFunc.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-28.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import "GlobalFunc.h"


@implementation GlobalFunc

CGRect ApplicationFrame(UIInterfaceOrientation interfaceOrientation)
{
	CGRect bounds = [[UIScreen mainScreen] applicationFrame];
	if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
		CGFloat width = bounds.size.width;
		bounds.size.width = bounds.size.height;
		bounds.size.height = width;
	}
	bounds.origin.x = 0;
	return bounds;
}

time_t convertTimeStamp(NSString *stringTime)
{
	time_t createdAt;
    struct tm created;
    time_t now;
    time(&now);
    
    if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		createdAt = mktime(&created);
	}
	return createdAt;
}

@end
