//
//  HelpPhotoViewController.h
//  SmartTao
//
//  Created by Wang Shiyou on 11-12-11.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpPhotoViewController : UIViewController <UIScrollViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UINavigationBar *titleBar;
@property (unsafe_unretained, nonatomic) IBOutlet UIPageControl *pageControll;
@property (nonatomic) int page;
@property (nonatomic) BOOL titleBarOn;
@property (nonatomic, strong) NSArray *images;

- (IBAction)cancel:(id)sender;

@end
