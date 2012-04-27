//
//  MoreInfoViewController.h
//  BFMan
//
//  Created by  on 12-2-9.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

typedef enum {
    SNS_SINA,
    SNS_TENC,
    SNS_RENR
} SNSType;

@interface MoreInfoViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic) SNSType snsType;
@property (nonatomic, strong) MBProgressHUD *hud;

@end
