//
//  MemberViewController.m
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "MemberViewController.h"

@interface MemberViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *profileTopicsArray;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *memberImageView;
@property (strong, nonatomic) IBOutlet UITableView *topicsTableView;

@end

@implementation MemberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.profileTopicsArray = [NSMutableArray new];
    [self jsonParser:self.memberID];
}

-(void)jsonParser: (NSString *)memberID
{
    [self.profileTopicsArray removeAllObjects];
    NSString *urlString =[NSString stringWithFormat:@"https://api.meetup.com/2/members?&sign=true&photo-host=public&member_id=%@&page=20&key=7e112a7d315af3ee18672e53675b43", memberID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSArray *jsonArray = [json objectForKey:@"results"];
        for (NSDictionary *user in jsonArray)
         {
             self.nameLabel.text = user[@"name"];
             self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", user[@"city"], user[@"state"]];
             NSDictionary *photo = user[@"photo"];
             NSURL *photoURL = [NSURL URLWithString:photo[@"photo_link"]];
             self.memberImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
             NSArray *topics = user[@"topics"];
             for (NSDictionary *topic in topics)
             {
                 NSString *topicName = topic[@"name"];
                 [self.profileTopicsArray addObject:topicName];
             }
        }
         [self.topicsTableView reloadData];
     }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicCell"];
    cell.textLabel.text = [self.profileTopicsArray objectAtIndex: indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.profileTopicsArray.count;
}

@end
