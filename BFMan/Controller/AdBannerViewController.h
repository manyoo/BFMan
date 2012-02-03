//
//  AdBannerViewController.h
//  SmartTao
//
//  Created by Wang Shiyou on 12-1-4.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLTServer.h"
#import "JSImageLoader.h"

@interface AdBannerViewController : UIViewController <JLTServerDelegate, CachedImageDelegate>

@property (nonatomic, strong) NSArray *jltAds;
@property (nonatomic, strong) JLTServer *server;
@property (nonatomic, strong) NSMutableArray *imgLoaderClients;
@property (nonatomic) NSInteger imgDownloaded;
@property (nonatomic) NSInteger currentAd;
@property (nonatomic, strong) UIImageView *displayingImageView;
@property (nonatomic, strong) UIImageView *backupImageView;
@property (nonatomic, unsafe_unretained) id delegate;

@end
