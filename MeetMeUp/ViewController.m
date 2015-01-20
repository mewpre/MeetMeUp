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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *meetupsArray;
@property (strong, nonatomic) IBOutlet UITableView *meetupsTableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.meetupsArray = [NSMutableArray new];
    [self jsonParser];
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

//Helper Method
-(void)jsonParser
{
    NSURL *url = [NSURL URLWithString:@"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=7e112a7d315af3ee18672e53675b43"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSArray *jsonArray = [json objectForKey:@"results"];
         for (NSDictionary *meetups in jsonArray)
         {
             MeetupEvent *newEvent = [MeetupEvent new];
             NSDictionary *venue = meetups[@"venue"];
             newEvent.name = meetups[@"name"];
             newEvent.location = [NSString stringWithFormat:@"%@\n%@\n%@, %@", venue[@"name"], venue[@"address_1"], venue[@"city"], venue[@"state"]];
             NSDictionary *group = meetups[@"group"];
             newEvent.hostingGroup = group[@"name"];
             newEvent.HTMLDescription = [NSString stringWithFormat:@"<html><head><title></title></head><body style=\"background:transparent;\"> %@ </body></html>", meetups[@"description"]];
             newEvent.RSVPcount = meetups[@"yes_rsvp_count"];
             newEvent.homePage = [NSURL URLWithString:meetups[@"event_url"]];
             [self.meetupsArray addObject:newEvent];
         }
         [self.meetupsTableView reloadData];
     }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    UITableViewCell *cell = (UITableViewCell *)sender;

    DetailViewController *dvc = segue.destinationViewController;
    // Find the index path from the selected table view cell
    // and use that to find the index of the creature in the creature array
    dvc.event = [self.meetupsArray objectAtIndex:[[self.meetupsTableView indexPathForCell:cell] row]];
}

@end
