//
//  AsyncImageView.m
//  Pazar
//
//  Created by Eric Wong on 11-7-11.
//  Copyright 2011 Manyoo Studio. All rights reserved.
//

#import "AsyncImageView.h"
#import "ItemImg.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "JSImageLoaderClient.h"

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
@synthesize usedInList, usedInPageControl, imageLoaderClient, noBorder, currentImage;

+ (UIImage *)cameraImage {
    if (globalImage == nil) {
        globalImage = [UIImage imageNamed:@"camera.png"];
    }
    return globalImage;
}

-(AsyncImageView *)initWithItemImg:(ItemImg *)image size:(IMGSize)size andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = image;
        self.userInteractionEnabled = NO;
        self.usedInList = NO;
        self.usedInPageControl = NO;
        self.noBorder = NO;
        
        NSString *imgUrl;
        if (size == IMG_SMALL) {
            imgUrl = [NSString stringWithFormat:@"%@_170x170.jpg", image.url];
        } else if (size == IMG_MIDDEL) {
            imgUrl = [NSString stringWithFormat:@"%@_310x310.jpg", image.url];
        } else {
            imgUrl = image.url;
        }
        
        self.imageLoaderClient = [[JSImageLoaderClient alloc] init];
        imageLoaderClient.request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        imageLoaderClient.delegate = self;
        [self displayImage:[AsyncImageView cameraImage]];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = NO;
        self.usedInList = NO;
        self.usedInPageControl = NO;
    }
    return self;
}

-(void)enableTouch {
    self.userInteractionEnabled = YES;
}

-(void)displayImage:(UIImage *)image {
    if (image == currentImage)
        return;

    self.currentImage = image;

    if (self.subviews.count > 0) {
        [[self.subviews objectAtIndex:0] removeFromSuperview];
    }
        
    UIImageView *imgView;
    if (usedInList) {
        //UIImage *newImage = [UIImage imageWithImage:image scaledToSize:self.frame.size];
        
        imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        imgView.layer.masksToBounds = YES;
        if (!noBorder) {
            imgView.layer.borderWidth = 0.5;
            imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    } else if (usedInPageControl) {
        CGFloat img_w = image.size.width, img_h = image.size.height;
        CGFloat bnd_w = self.bounds.size.width, bnd_h = self.bounds.size.height;
        CGFloat scale = bnd_h / img_h, scale_w = bnd_w / img_w;
        if (scale > scale_w) {
            scale = scale_w;
        }
        CGSize newSize = CGSizeMake(img_w * scale, img_h * scale);
        UIImage *newImage = [UIImage imageWithImage:image scaledToSize:newSize];

        imgView = [[UIImageView alloc] initWithImage:newImage];
        imgView.frame = CGRectMake((self.frame.size.width - newSize.width) / 2, (self.frame.size.height - newSize.height) / 2, newSize.width, newSize.height);
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);    
        imgView.clipsToBounds = YES;

        [[imgView layer] setCornerRadius:6.0];
        [[imgView layer] setMasksToBounds:YES];
        
    } else {
        imgView = [[UIImageView alloc] initWithImage:image];
        imgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    }
    
    [self addSubview:imgView];
    [imgView setNeedsLayout];
    [self setNeedsLayout];
}


-(void)getImage {
    if (currentImage != [AsyncImageView cameraImage]) {
        return;
    }
    JSImageLoader *imageLoader = [JSImageLoader sharedInstance];
    [imageLoader addClientToDownloadQueue:imageLoaderClient];
}

-(void)setNewImage:(ItemImg *)image size:(IMGSize)size {
    self.image = image;
    self.userInteractionEnabled = NO;
    self.usedInList = NO;
    self.usedInPageControl = NO;
    NSString *imgUrl;
    if (size == IMG_SMALL) {
        imgUrl = [NSString stringWithFormat:@"%@_170x170.jpg", image.url];
    } else if (size == IMG_MIDDEL) {
        imgUrl = [NSString stringWithFormat:@"%@_310x310.jpg", image.url];
    } else {
        imgUrl = image.url;
    }
    self.imageLoaderClient = [[JSImageLoaderClient alloc] init];
    imageLoaderClient.request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    imageLoaderClient.delegate = self;
    [self displayImage:[AsyncImageView cameraImage]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)renderImage:(UIImage *)image forClient:(JSImageLoaderClient *)client {
	// Check if the request is coming from the right client
	if (client == imageLoaderClient) {
		// Render the image
        [self displayImage:image];
	}
}

- (void)dealloc {
    [imageLoaderClient cancelFetch];
    imageLoaderClient.delegate = nil;
}

@end
