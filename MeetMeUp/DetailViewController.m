//
//  DetailViewController.m
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "DetailViewController.h"
#import "WebViewController.h"
#import "MemberViewController.h"
#import "Comment.h"
#import "Member.h"

@interface DetailViewController ()<UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *hostingGroupLabel;
@property (strong, nonatomic) IBOutlet UILabel *RSVPLabel;
@property (strong, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;
@property BOOL didStartFirstRequest;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.descriptionWebView.delegate = self;
    self.navigationItem.title = self.event.name;
    self.hostingGroupLabel.text = self.event.hostingGroup;
    self.RSVPLabel.text = [NSString stringWithFormat:@"%@ %@ attending", self.event.RSVPcount, self.event.memberTitle];
    [self.descriptionWebView loadHTMLString:[self.event.HTMLDescription description] baseURL:nil];
    [Comment retrieveComments:self.event.eventID withCompletion:^(NSArray *commentsArray)
    {
        self.event.commentsArray = commentsArray;
        [self.commentsTableView reloadData];
    }];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    Comment *commentAtIndex = [self.event.commentsArray objectAtIndex:indexPath.row];
    NSString *commentString = commentAtIndex.comment;
    cell.textLabel.text = commentString;
    cell.textLabel.numberOfLines = 3;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateString = [df stringFromDate:commentAtIndex.commentDate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", commentAtIndex.member.name, dateString];
    cell.detailTextLabel.numberOfLines = 3;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.event.commentsArray.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"buttonSegue"])
    {
        WebViewController *wvc = segue.destinationViewController;
        wvc.homePageURL = self.event.homePage;
    }
    else if ([segue.identifier isEqualToString:@"cellSegue"])
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        MemberViewController *mvc = segue.destinationViewController;
        Comment *selectedComment = [self.event.commentsArray objectAtIndex:[[self.commentsTableView indexPathForCell:cell] row]];
        mvc.member = selectedComment.member;
    }
}


@end
