//
//  DetailViewController.m
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "DetailViewController.h"
#import "WebViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *hostingGroupLabel;
@property (strong, nonatomic) IBOutlet UILabel *RSVPLabel;
@property (strong, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property BOOL didStartFirstRequest;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptionWebView.delegate = self;
    self.eventNameLabel.text = self.event.name;
    self.hostingGroupLabel.text = self.event.hostingGroup;
    self.RSVPLabel.text = [NSString stringWithFormat:@"RSVP Count: %@", self.event.RSVPcount];
    [self.descriptionWebView loadHTMLString:[self.event.HTMLDescription description] baseURL:nil];
    // Do any additional setup after loading the view.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    {
        if (self.didStartFirstRequest)
        {
            return NO;
        }
        self.didStartFirstRequest = YES;
        return YES;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WebViewController *wvc = segue.destinationViewController;
    wvc.homePageURL = self.event.homePage;
}


@end
