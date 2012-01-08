    //
//  OAuthViewController.m
//  MinBlog4Sina
//
//  Created by 水的右边 on 11-4-28.
//  Copyright 2011 http://www.cnblogs.com/hll2008/ All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OAuthViewController.h"
#import "GlobalFunc.h"

@implementation OAuthViewController
@synthesize oauth;
@synthesize orientation;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

-(id)initWithOAuth:(OAuth *)aOAuth delegate:(id)aDelegate
{
	if (self=[super init]) {
		self.oauth=aOAuth;
		delegate=aDelegate;
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	UIView *_v=[[UIView alloc] initWithFrame: ApplicationFrame(self.orientation)];
	self.view=_v;
	[_v release];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
	navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	
	CGRect frame = ApplicationFrame(self.orientation);
	frame.origin.y = 44;
	frame.size.height -= 44;
	
	webView = [[UIWebView alloc] initWithFrame: frame];
	webView.alpha = 0.0;
	webView.delegate = self;
	
	NSURLRequest *request = oauth.authorizeURLRequest;
	if (request) {
		[webView loadRequest: request];
	}
	[self.view addSubview: webView];
	[self.view addSubview:navBar];
	
	blockerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
	blockerView.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.8];
	blockerView.center=CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
	blockerView.alpha=0.0;
	blockerView.clipsToBounds=YES;
	if ([blockerView.layer respondsToSelector:@selector(setCornerRadius:)]) {
		[blockerView.layer setCornerRadius:10];
	}
	
	UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, blockerView.bounds.size.width, 15)];
	label.text=NSLocalizedString(@"请稍等...",nil);
	label.textColor=[UIColor whiteColor];
	label.backgroundColor=[UIColor clearColor];
	label.textAlignment=UITextAlignmentCenter;
	label.font=[UIFont boldSystemFontOfSize:14];
	[blockerView addSubview:label];
	[label release];
	
	UIActivityIndicatorView *spinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	spinner.center=CGPointMake(blockerView.bounds.size.width/2, blockerView.bounds.size.height/2+5);
	[blockerView addSubview:spinner];
	[self.view addSubview:blockerView];
	[spinner startAnimating];
	[spinner release];
	
	UINavigationItem *navItem=[[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"新浪微博授权认证",nil)];
	navItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease];
	[navBar pushNavigationItem:navItem animated:YES];
	[navItem release];
	
	[navBar release];
}

-(NSString *)getPinInWebView:(UIWebView *)aWebView
{
	//NSString *js = @"var d = document.getElementById('oauth-pin'); if (d == null) d = document.getElementById('oauth_pin'); if (d) d = d.innerHTML; if (d == null) {var r = new RegExp('\\\\s[0-9]+\\\\s'); d = r.exec(document.body.innerHTML); if (d.length > 0) d = d[0];} d.replace(/^\\s*/, '').replace(/\\s*$/, ''); d;";
	//NSString *pin = [aWebView stringByEvaluatingJavaScriptFromString: js];
	//if (pin.length==6) {
	//	NSLog(@"html0:%@",pin);
	//	return pin;
	//}
	NSString *html = [aWebView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];
	if (html.length==0) {
		return nil;
	}
	
	const char *rawHTML = (const char *) [html UTF8String];
	int length = strlen(rawHTML),chunkLength = 0;
	for (int i=0; i<length; i++) {
		if (rawHTML[i]<'0' || rawHTML[i]>'9') {
			if (chunkLength==6) {
				char *buffer = (char *) malloc(chunkLength + 1);
				memmove(buffer, &rawHTML[i - chunkLength], chunkLength);
				buffer[chunkLength] = 0;
				
				NSString *pin = [NSString stringWithUTF8String: buffer];
	
				free(buffer);
				return pin;
			}
		}else {
			chunkLength++;
		}

	}
	return nil;
}

-(void)denied
{
	if ([delegate respondsToSelector: @selector(OAuthViewControllerCancel:)])
	{
		[delegate OAuthViewControllerCancel: @""];
	}
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 0.0];
}

-(void)getPin:(NSString *)pin
{
	oauth.pin=pin;
	[oauth requestAccessToken];
	if ([delegate respondsToSelector: @selector(OAuthViewControllerOk:)])
	{
		[delegate OAuthViewControllerOk: pin];
	}
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 1.0];
}

-(void)cancel:(id)sender
{
	if ([delegate respondsToSelector: @selector(OAuthViewControllerCancel:)])
	{
		[delegate OAuthViewControllerCancel: @""];
	}
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 0.0];
}

-(void)webViewDidStartLoad:(UIWebView *)aWebView
{
	[UIView beginAnimations:nil context:nil];
	blockerView.alpha=1.0;
	[UIView commitAnimations];
}

-(void)webViewDidFinishLoad:(UIWebView *)aWebView
{
	NSString *authPin = [self getPinInWebView: aWebView];
	if (authPin.length) {
		[self getPin:authPin];
	}
	
	[UIView beginAnimations:nil context:nil];
	blockerView.alpha=0.0;
	[UIView commitAnimations];
	
	if ([aWebView isLoading]) {
		aWebView.alpha=0.0;
	}else {
		aWebView.alpha=1.0;
	}
}

-(BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)aRequest navigationType:(UIWebViewNavigationType)aNavigationType
{
	/*
	NSString *url=[[NSString alloc] initWithFormat:@"%@",[aRequest URL]];
	if ([url hasSuffix:@"#"]) {
		[url release];
		[self denied];
		return NO;
	}
	[url release];
	 */
	return YES;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	self.view=nil;
	[oauth release];
	[webView release];
	[blockerView release];
    [super dealloc];
}


@end
