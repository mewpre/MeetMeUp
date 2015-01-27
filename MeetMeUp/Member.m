//
//  Member.m
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/26/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Member.h"

@implementation Member

- (void)setMemberData:(NSDictionary *)dictionary
{
    self.location = [NSString stringWithFormat:@"%@, %@", dictionary[@"city"], dictionary[@"state"]];
    NSURL *photoURL = [NSURL URLWithString:dictionary[@"photo"][@"photo_link"]];
    self.imageData = [NSData dataWithContentsOfURL:photoURL];
    NSArray *topics = dictionary[@"topics"];
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary *topic in topics)
    {
        NSString *topicName = topic[@"name"];
        [tempArray addObject:topicName];
    }
    self.topics = tempArray;
}

- (void)retrieveMemberData: (NSString *)memberID withCompletion:(void(^)(NSArray *topicsArray))complete
{
    // Start animating the spinner on view load
    NSString *urlString =[NSString stringWithFormat:@"https://api.meetup.com/2/members?&sign=true&photo-host=public&member_id=%@&page=20&key=61843107c6fc55826453135e261d", memberID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"Retrieve Member:%@", connectionError);
         if (!connectionError)
         {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSArray *user = [json objectForKey:@"results"];
             NSDictionary *userDictionary = [user firstObject];
             [self setMemberData:userDictionary];
         }
         complete(self.topics);
     }];
}

@end
