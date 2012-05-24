//
//  AsyncImageView.h
//  Pazar
//
//  Created by Eric Wong on 11-7-11.
//  Copyright 2011 Manyoo Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemImg;
@class ASIHTTPRequest;

typedef enum {
    IMG_SMALL,
    IMG_MIDDEL,
    IMG_BIG
} IMGSize;

@interface AsyncImageView : UIView

@property (nonatomic, strong) ItemImg *image;
@property (nonatomic) BOOL usedInList;
@property (nonatomic) BOOL usedInPageControl;
@property (nonatomic) BOOL noBorder;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ASIHTTPRequest *request;
@property (nonatomic, strong) NSString *urlStr;

+ (UIImage *)cameraImage;

-(AsyncImageView *)initWithItemImg:(ItemImg *)image size:(IMGSize)size andFrame:(CGRect)frame;

-(void)displayImage:(UIImage *)image;
-(void)getImage;
-(void)enableTouch;
-(void)setNewImage:(ItemImg *)image size:(IMGSize)size;
-(void)setSelected:(BOOL)sel;

@end
