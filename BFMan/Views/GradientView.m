//
//  GradientView.m
//  SmartTao
//
//  Created by Wang Shiyou on 11-10-11.
//  Copyright (c) 2011年 Manyoo Studio. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView
@synthesize startColor, endColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    const CGFloat *startColors = CGColorGetComponents(startColor.CGColor);
    const CGFloat *endColors = CGColorGetComponents(endColor.CGColor);
    CGFloat components[8] = { startColors[0], startColors[1], startColors[2], startColors[3],  // Start color
                              endColors[0], endColors[1], endColors[2], endColors[3] }; // End color

    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);

    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), currentBounds.size.height);
    CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, bottomCenter, 0);

    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
}

@end
