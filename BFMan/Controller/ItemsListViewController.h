//
//  ItemsListViewController.h
//  BFMan
//
//  Created by  on 12-1-31.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBServer.h"

@interface ItemsListViewController : UITableViewController <TBServerDelegate>

@property (nonatomic, strong) NSMutableArray *huabaoAuctions;
@property (nonatomic, strong) TBServer *server;
@property (nonatomic, unsafe_unretained) id delegate;

@end
