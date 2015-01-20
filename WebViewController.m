//
//  WebViewController.m
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *addressRequest = [NSURLRequest requestWithURL:self.homePageURL];
    [self.webView loadRequest:addressRequest];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.spinner startAnimating];
    self.spinner.hidden = false;
    //    self.navigationBarTitle.title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.spinner stopAnimating];
    self.spinner.hidden = true;
    [self updateButtons];
}

//Helper Method - updates the states of navigation buttons
-(void)updateButtons
{
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
}

- (IBAction)onBackButtonTapped:(id)sender
{
    [self.webView goBack];
}

- (IBAction)onForwardButtonTapped:(id)sender
{
    [self.webView goForward];
}

@end
