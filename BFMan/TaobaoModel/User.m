//
//  User.m
//  SmartTao
//
//  Created by  on 11-9-18.
//  Copyright (c) 2011 Manyoo Studio. All rights reserved.
//

#import "User.h"
#import "UserCredit.h"
#import "Location.h"

NSArray *user_fields = nil;

User *globalUser = nil;

@implementation User
@synthesize uid, nick, sex, buyerCredit, location, birthday, status, alipayBind, alipayAccount, 
alipayId, avatar, avatarImage, email;

+ (User *)currentUser {
    return globalUser;
}

+ (NSArray *)fields {
    if (user_fields == nil) {
        user_fields = [[NSArray alloc] initWithObjects:@"uid", @"nick", @"sex", @"buyer_credit", @"location",
                       @"birthday", @"status", @"alipay_bind", @"alipay_account", @"alipay_no", @"avatar",
                       @"email", nil];
    }
    return user_fields;
}

+ (User *)userFromResponse:(NSDictionary *)respDict {
    User *user = [[User alloc] init];
    NSDictionary *userResp = [respDict objectForKey:@"user_get_response"];
    NSDictionary *userDict = [userResp objectForKey:@"user"];
    
    user.uid = [userDict objectForKey:@"uid"];
    user.nick = [userDict objectForKey:@"nick"];
    
    NSString *sexStr = [userDict objectForKey:@"sex"];
    if (sexStr != nil) {
        if ([sexStr isEqualToString:@"m"]) {
            user.sex = SEX_MALE;
        } else if ([sexStr isEqualToString:@"f"])
            user.sex = SEX_FEMALE;
        else
            user.sex = SEX_UNDEFINED;
    } else
        user.sex = SEX_UNDEFINED;
    
    user.buyerCredit = [UserCredit userCreditFromResponse:[userDict objectForKey:@"buyer_credit"]];
    user.location = [Location locationFromResponse:[userDict objectForKey:@"location"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    user.birthday = [formatter dateFromString:[userDict objectForKey:@"birthday"]];
    
    NSString *statusStr = [userDict objectForKey:@"status"];
    if (statusStr != nil) {
        if ([statusStr isEqualToString:@"normal"]) {
            user.status = STATUS_NORMAL;
        } else if ([statusStr isEqualToString:@"inactive"]) {
            user.status = STATUS_INACTIVE;
        } else if ([statusStr isEqualToString:@"delete"]) {
            user.status = STATUS_DELETE;
        } else if ([statusStr isEqualToString:@"reeze"]) {
            user.status = STATUS_REEZE;
        } else
            user.status = STATUS_SUPERVISE;        
    }

    
    if ([[userDict objectForKey:@"alipay_bind"] isEqualToString:@"bind"]) {
        user.alipayBind = YES;
    } else
        user.alipayBind = NO;
    
    user.alipayAccount = [userDict objectForKey:@"alipay_account"];
    user.alipayId = [userDict objectForKey:@"alipay_no"];
    user.avatar = [userDict objectForKey:@"avatar"];
    user.email = [userDict objectForKey:@"email"];
    
    globalUser = user;
    
    return user;
}

@end
