//
//  SearchButton.m
//  SmartTao
//
//  Created by  on 12-3-11.
//  Copyright (c) 2012年 Manyoo Studio. All rights reserved.
//

#import "SearchButton.h"

@implementation SearchButton
@synthesize pressed, bgImage, bgPressedImage;

- (UIImage *) gradientImageFrom:(UIColor *)bc to:(UIColor *)ec {
    // Open image context.
    UIGraphicsBeginImageContext(CGSizeMake(160, 40));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    const CGFloat *startColors = CGColorGetComponents(bc.CGColor);
    const CGFloat *endColors = CGColorGetComponents(ec.CGColor);
    CGFloat components[8] = { startColors[0], startColors[1], startColors[2], startColors[3],  // Start color
        endColors[0], endColors[1], endColors[2], endColors[3] }; // End color
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    
    CGPoint topCenter = CGPointMake(80, 0.0f);
    CGPoint bottomCenter = CGPointMake(80, 40);
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, bottomCenter, 0);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
    
    return image;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pressed = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        CGFloat c1 = 255.0/255.0, c2 = 239.0/255.0;
        UIColor *start = [UIColor colorWithRed:c1 green:c1 blue:c1 alpha:1.0];
        UIColor *end = [UIColor colorWithRed:c2 green:c2 blue:c2 alpha:1.0];
        self.bgImage = [self gradientImageFrom:start to:end];
        
        UIColor *s2 = [UIColor colorWithRed:112.0/255 green:119.0/255 blue:133.0/255 alpha:1.0];
        UIColor *e2 = [UIColor colorWithRed:145.0/255 green:153.0/255 blue:172.0/255 alpha:1.0];
        self.bgPressedImage = [self gradientImageFrom:s2 to:e2];
        [self setBackgroundImage:bgImage forState:UIControlStateNormal];
        [self setBackgroundImage:bgPressedImage forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)changeButton {
    if (pressed) {
        [self setBackgroundImage:bgImage forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    } else {
        [self setBackgroundImage:bgPressedImage forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    self.pressed = !pressed;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
