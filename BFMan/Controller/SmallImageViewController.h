//
//  SmallImageViewController.h
//  BFMan
//
//  Created by  on 12-4-26.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SmallImageViewControllerDelegate <NSObject>

- (void)pictureSelected:(int)idx;

@end

@interface SmallImageViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *pictures;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *subViews;
@property (nonatomic) int page;

@property (nonatomic, unsafe_unretained) id<SmallImageViewControllerDelegate> delegate;

@end
