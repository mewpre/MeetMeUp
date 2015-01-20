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

@interface DetailViewController ()<UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *hostingGroupLabel;
@property (strong, nonatomic) IBOutlet UILabel *RSVPLabel;
@property (strong, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property (strong, nonatomic) IBOutlet UITableView *commentsTableView;
@property BOOL didStartFirstRequest;

@property NSMutableArray *commentsArray;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptionWebView.delegate = self;
    self.navigationItem.title = self.event.name;
    self.eventNameLabel.text = self.event.name;
    self.hostingGroupLabel.text = self.event.hostingGroup;
    self.RSVPLabel.text = [NSString stringWithFormat:@"%@ %@ attending", self.event.RSVPcount, self.event.memberTitle];
    [self.descriptionWebView loadHTMLString:[self.event.HTMLDescription description] baseURL:nil];
    self.commentsArray = [NSMutableArray new];
    [self jsonParser:self.event.eventID];
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

-(void)jsonParser: (NSString *)eventID
{
    [self.commentsArray removeAllObjects];
    NSString *urlString =[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=%@&page=20&key=7e112a7d315af3ee18672e53675b43", eventID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSArray *jsonArray = [json objectForKey:@"results"];
         for (NSDictionary *comments in jsonArray)
         {
             Comment *newComment = [Comment new];
             newComment.memberName = comments[@"member_name"];
             newComment.memberID = comments[@"member_id"];
             double time = [comments[@"time"] doubleValue] /1000;
             newComment.commentDate = [NSDate dateWithTimeIntervalSince1970:time];
             newComment.comment = comments[@"comment"];
             [self.commentsArray addObject:newComment];
         }
         [self.commentsTableView reloadData];
     }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    Comment *commentAtIndex = [self.commentsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = commentAtIndex.comment;
    cell.textLabel.numberOfLines = 3;
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateString = [df stringFromDate:commentAtIndex.commentDate];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@", commentAtIndex.memberName, dateString];
    cell.detailTextLabel.numberOfLines = 2;
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArray.count;
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
        Comment *selectedComment = [self.commentsArray objectAtIndex:[[self.commentsTableView indexPathForCell:cell] row]];
        mvc.memberID = selectedComment.memberID;
        
    }

}


@end
