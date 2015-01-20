//
//  ViewController.m
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "ViewController.h"
#import "MeetupEvent.h"
#import "DetailViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property NSMutableArray *meetupsArray;
@property (strong, nonatomic) IBOutlet UITableView *meetupsTableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBarItem;

@property UIActivityIndicatorView *navbarActivityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.meetupsArray = [NSMutableArray new];

    // Create a navbar activity indicator, insert it into a UIBarButtonItem and set it right of the nav item
    self.navbarActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

    UIBarButtonItem *navSpinnerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navbarActivityIndicator];
    [self.navigationItem setRightBarButtonItem:navSpinnerBarButtonItem];

    [self jsonParser:@"mobile"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.meetupsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    MeetupEvent *eventAtIndex = [self.meetupsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = eventAtIndex.name;
    cell.detailTextLabel.text = eventAtIndex.location;
    cell.detailTextLabel.numberOfLines = 3;
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = searchBar.text;
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    //only do a search if searchTerm does not consist of only whitespace
    if (![[searchTerm stringByTrimmingCharactersInSet: set] length] == 0)
    {
        [self jsonParser:searchTerm];
    }
}

//Helper Method
-(void)jsonParser: (NSString *)searchTerm
{
    // Start animating the spinner on view load
    [self.navbarActivityIndicator startAnimating];
    [self.meetupsArray removeAllObjects];
    NSString *urlString =[NSString stringWithFormat: @"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=7e112a7d315af3ee18672e53675b43", searchTerm];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSArray *jsonArray = [json objectForKey:@"results"];
         for (NSDictionary *meetups in jsonArray)
         {
             MeetupEvent *newEvent = [MeetupEvent new];
             newEvent.name = meetups[@"name"];
             newEvent.HTMLDescription = [NSString stringWithFormat:@"<html><head><title></title></head><body style=\"background:transparent;\"> %@ </body></html>", meetups[@"description"]];
             newEvent.RSVPcount = meetups[@"yes_rsvp_count"];
             newEvent.homePage = [NSURL URLWithString:meetups[@"event_url"]];
             newEvent.eventID = meetups[@"id"];

             NSDictionary *venue = meetups[@"venue"];
             newEvent.location = [NSString stringWithFormat:@"%@\n%@\n%@, %@", venue[@"name"], venue[@"address_1"], venue[@"city"], venue[@"state"]];
             
             NSDictionary *group = meetups[@"group"];
             newEvent.memberTitle = group[@"who"];
             newEvent.hostingGroup = group[@"name"];
             [self.meetupsArray addObject:newEvent];
         }
         [self.meetupsTableView reloadData];
         [self.navbarActivityIndicator stopAnimating];
     }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    UITableViewCell *cell = sender;
    DetailViewController *dvc = segue.destinationViewController;
    dvc.event = [self.meetupsArray objectAtIndex:[[self.meetupsTableView indexPathForCell:cell] row]];
}

@end
