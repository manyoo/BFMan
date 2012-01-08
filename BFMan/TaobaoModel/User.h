//
//  User.h
//  SmartTao
//
//  Created by  on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SEX_MALE,
    SEX_FEMALE,
    SEX_UNDEFINED
} UserSex;

typedef enum {
    STATUS_NORMAL,
    STATUS_INACTIVE,
    STATUS_DELETE,
    STATUS_REEZE,
    STATUS_SUPERVISE
} UserStatus;

@class UserCredit;
@class Location;
@class ItemImg;

@interface User : NSObject

// user info from Taobao
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *nick;
@property (nonatomic) UserSex sex;
@property (strong, nonatomic) UserCredit *buyerCredit;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) NSDate *birthday;
@property (nonatomic) UserStatus status;
@property (nonatomic) BOOL alipayBind;
@property (strong, nonatomic) NSString *alipayAccount;
@property (strong, nonatomic) NSString *alipayId;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) ItemImg *avatarImage;
@property (strong, nonatomic) NSString *email;

+ (User *)userFromResponse:(NSDictionary *)respDict;
+ (NSArray *)fields;

+ (User *)currentUser;

@end
