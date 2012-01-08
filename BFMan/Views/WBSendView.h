//
//  WBSendView.h
//  DemoApp
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol WBSendViewDelegate;

@interface WBSendView : UIView <UITextViewDelegate>{
	UIDeviceOrientation _orientation;
	BOOL _showingKeyboard;
		
	UITextView * _weiboContentTextView;
	UIButton * _sendWeiboButton; 
	UIButton * _clearTextButton;
	UILabel * _titleLabel;
	UILabel * _wordCountLabel;
	
	UIView * _panelView;
	
	UIImageView * _weiboImageView;
	UIButton * _clearImageButton;
	
	UIImage * _weiboImageData;
	UIImageView* _panelImageView;
    NSString *_imageUrl;
    
    NSString *_additionalText;
}

@property(nonatomic, unsafe_unretained) id<WBSendViewDelegate> delegate;

/*
  You should not initialze the sendview in your viewController with this function, 
  using [_weibo showSendViewWithWeiboText:andImage:andDelegate:] instead,
  or draw the UI youself and implement [_weibo postWeiboRequestWithText:andImage:andDelegate:] to send new weibo. 
 
*/
- (id)initWithWeiboText:(NSString*) weiboText withImage:(UIImage*)image url:(NSString *)url aditionalText:(NSString *)text andDelegate:(id)del;   

//show and dismiss the sendview 
- (void)show;
- (void)dismiss:(BOOL)animated;

@end



@protocol WBSendViewDelegate <NSObject>

@optional

/**
 * Called when the sendView shows and dismisses.
 */

- (void)sendViewWillAppear:(WBSendView*)sendView;		//Called when the sendview will appear.

- (void)sendViewDidLoad:(WBSendView*)sendView;			//Called when the sendview is loaded.

- (void)sendViewWillDisappear:(WBSendView*)sendView;	//Called when the sendview is about to dissmiss.

- (void)sendViewDidDismiss:(WBSendView*)sendView;		//Called when the sendview is dismissed.

- (void)postSucceeded;

- (void)postFailed;

@end