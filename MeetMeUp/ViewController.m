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

@property (strong, nonatomic) NSArray *meetupsArray;
@property (strong, nonatomic) IBOutlet UITableView *meetupsTableView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBarItem;

@property UIActivityIndicatorView *navbarActivityIndicator;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.meetupsArray = [NSMutableArray new];
    [self createNavigationBarActivityIndicator];
    [self.navbarActivityIndicator startAnimating];
    [MeetupEvent retrieveMeetups:@"mobile" withCompletion:^(NSArray *meetupEventsArray)
    {
        self.meetupsArray = meetupEventsArray;
    }];
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
        [self.navbarActivityIndicator startAnimating];
        [MeetupEvent retrieveMeetups:searchTerm withCompletion:^(NSArray *meetupEventsArray)
        {
            self.meetupsArray = meetupEventsArray;
        }];
    }
}

- (void)setMeetupsArray:(NSArray *)meetupsArray
{
    _meetupsArray = meetupsArray;
    [self.meetupsTableView reloadData];
    [self.navbarActivityIndicator stopAnimating];
}

//Helper method for navigation bar activity indicator
-(void)createNavigationBarActivityIndicator
{
    // Create a navbar activity indicator, insert it into a UIBarButtonItem and set it right of the nav item
    self.navbarActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

    UIBarButtonItem *navSpinnerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navbarActivityIndicator];
    [self.navigationItem setRightBarButtonItem:navSpinnerBarButtonItem];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    UITableViewCell *cell = sender;
    DetailViewController *dvc = segue.destinationViewController;
    dvc.event = [self.meetupsArray objectAtIndex:[[self.meetupsTableView indexPathForCell:cell] row]];
}

@end
