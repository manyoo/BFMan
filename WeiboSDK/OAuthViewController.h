//
//  OAuthController.h
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-28.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuth.h"

@protocol OAuthViewControllerDelegate <NSObject>
- (void) OAuthViewControllerCancel: (NSString *) text;
- (void) OAuthViewControllerOk: (NSString *) text;
@end

@interface OAuthViewController : UIViewController<UIWebViewDelegate> {
	
	OAuth *oauth;
	UIWebView *webView;
	UIView *blockerView;
	UIInterfaceOrientation orientation;
	id<OAuthViewControllerDelegate> delegate;
}

@property (nonatomic,retain)OAuth *oauth;
@property (nonatomic,assign)UIInterfaceOrientation orientation;

-(id)initWithOAuth:(OAuth *)aOAuth delegate:(id<OAuthViewControllerDelegate>)aDelegate;

@end
