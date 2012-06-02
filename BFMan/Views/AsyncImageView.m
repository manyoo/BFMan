//
//  AsyncImageView.m
//  Pazar
//
//  Created by Eric Wong on 11-7-11.
//  Copyright 2011 Manyoo Studio. All rights reserved.
//

#import "AsyncImageView.h"
#import "ItemImg.h"
#import <QuartzCore/QuartzCore.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ImageMemCache.h"

UIImage *globalImage = nil;

@interface UIImage (Scaling)

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end

@implementation UIImage (Scaling)

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(newSize);
        }
    } else {
        UIGraphicsBeginImageContext(newSize);
    }    
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end


@implementation AsyncImageView

@synthesize image = _image;
@synthesize usedInList, usedInPageControl, noBorder, currentImage, isSelected, request, urlStr, imageView;


-(AsyncImageView *)initWithItemImg:(ItemImg *)image size:(IMGSize)size andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = image;
        self.userInteractionEnabled = NO;
        self.usedInList = NO;
        self.usedInPageControl = NO;
        self.noBorder = NO;
        if (size == IMG_SMALL) {
            self.urlStr = [NSString stringWithFormat:@"%@_170x170.jpg", image.url];
        } else if (size == IMG_MIDDEL) {
            self.urlStr = [NSString stringWithFormat:@"%@_310x310.jpg", image.url];
        } else {
            self.urlStr = image.url;
        }
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:imageView];
        
        [self displayImage:[UIImage imageNamed:@"camera.png"]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:imageView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = NO;
        self.usedInList = NO;
        self.usedInPageControl = NO;
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
    }
    return self;
}

+ (UIImage *)cameraImage {
    if (globalImage == nil) {
        globalImage = [UIImage imageNamed:@"camera.png"];
    }
    return globalImage;
}

-(void)enableTouch {
    self.userInteractionEnabled = YES;
}

-(void)displayImage:(UIImage *)image {
    if (usedInList) {        
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.masksToBounds = YES;
        if (!noBorder) {
            imageView.layer.borderWidth = 0.5;
            imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    } else if (usedInPageControl) {
        CGFloat img_w = image.size.width, img_h = image.size.height;
        CGFloat bnd_w = self.bounds.size.width, bnd_h = self.bounds.size.height;
        CGFloat scale = bnd_h / img_h, scale_w = bnd_w / img_w;
        if (scale > scale_w) {
            scale = scale_w;
        }
        CGSize newSize = CGSizeMake(img_w * scale, img_h * scale);
        
        imageView.frame = CGRectMake((self.frame.size.width - newSize.width) / 2, (self.frame.size.height - newSize.height) / 2, newSize.width, newSize.height);
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);    
        imageView.clipsToBounds = YES;
        
        [[imageView layer] setCornerRadius:6.0];
        [[imageView layer] setMasksToBounds:YES];
    } else {
        imageView.image = image;
        imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                      | UIViewAutoresizingFlexibleHeight);
    }
    
    if (isSelected) {
        imageView.layer.borderWidth = 2;
        imageView.layer.borderColor = [UIColor orangeColor].CGColor;
    } else {
        imageView.layer.borderWidth = 0.0;
        imageView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)getImage {
    UIImage *imgCached = [[ImageMemCache sharedImageMemCache] getImageForKey:urlStr];
    if (imgCached == nil) {
        self.request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
        request.delegate = self;
        request.downloadCache = [ASIDownloadCache sharedCache];
        request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
        request.cachePolicy = ASIOnlyLoadIfNotCachedCachePolicy;
        [request startAsynchronous];
        [self displayImage:[UIImage imageNamed:@"camera.png"]];
    } else {
        [self displayImage:imgCached];
    }
}

-(void)setNewImage:(ItemImg *)image size:(IMGSize)size {
    [request cancel];
    if (image == nil) {
        [self displayImage:nil];
        return;
    }
    self.image = image;
    
    if (size == IMG_BIG) {
        self.urlStr = image.url;
    } else if (size == IMG_MIDDEL) {
        self.urlStr = [NSString stringWithFormat:@"%@_310x310.jpg",image.url];
    } else {
        self.urlStr = [NSString stringWithFormat:@"%@_170x170.jpg",image.url];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)requestFinished:(ASIHTTPRequest *)req {
    UIImage *image = [UIImage imageWithData:req.responseData];
    [self displayImage:image];
    [[ImageMemCache sharedImageMemCache] addImage:image forKey:urlStr];
}

- (void)dealloc {
    [request clearDelegatesAndCancel];
}


- (void)setSelected:(BOOL)sel {
    UIImageView *imgView = [self.subviews objectAtIndex:0];
    if (imgView == nil) {
        return;
    }
    self.isSelected = sel;
    
    if (sel) {
        imgView.layer.borderWidth = 2;
        imgView.layer.borderColor = [UIColor orangeColor].CGColor;
    } else {
        imgView.layer.borderWidth = 0.0;
        imgView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
