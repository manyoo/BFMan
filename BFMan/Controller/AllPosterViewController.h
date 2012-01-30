//
//  AllPosterViewController.h
//  BFMan
//
//  Created by  on 12-1-22.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "PosterViewController.h"
#import "TBServer.h"

@interface AllPosterViewController : PosterViewController <TBServerDelegate>

@property (nonatomic, strong) TBServer *server;

@end
