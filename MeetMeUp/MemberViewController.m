//
//  MemberViewController.m
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "MemberViewController.h"
#import "Member.h"

@interface MemberViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *profileTopicsArray;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *memberImageView;
@property (strong, nonatomic) IBOutlet UITableView *topicsTableView;

@property UIActivityIndicatorView *navbarActivityIndicator;

@end

@implementation MemberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.profileTopicsArray = [NSMutableArray new];
    [self createNavigationActivityIndicator];
    [self.navbarActivityIndicator startAnimating];
    [self.member retrieveMemberData:self.member.memberID withCompletion:^(NSArray *topicsArray)
    {
        self.navigationItem.title = self.member.name;
        self.locationLabel.text = self.member.location;
        self.memberImageView.image = [UIImage imageWithData:self.member.imageData];
        self.profileTopicsArray = topicsArray;
        [self.topicsTableView reloadData];
    }];
}

- (void)setProfileTopicsArray:(NSArray *)profileTopicsArray
{
    _profileTopicsArray = profileTopicsArray;
    [self.topicsTableView reloadData];
    [self.navbarActivityIndicator stopAnimating];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicCell"];
    cell.textLabel.text = [self.profileTopicsArray objectAtIndex: indexPath.row];
    return cell;
}

- (void)createNavigationActivityIndicator
{
    // Create a navbar activity indicator, insert it into a UIBarButtonItem and set it right of the nav item
    self.navbarActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

    UIBarButtonItem *navSpinnerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.navbarActivityIndicator];
    [self.navigationItem setRightBarButtonItem:navSpinnerBarButtonItem];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.profileTopicsArray.count;
}

@end
