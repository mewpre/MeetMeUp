//
//  MeetupEvent.m
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "MeetupEvent.h"
#import "Comment.h"

@implementation MeetupEvent

-(instancetype)initWithDictionary: (NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.name = dictionary[@"name"];
        self.HTMLDescription = [NSString stringWithFormat:@"<html><head><title></title></head><body style=\"background:transparent;\"> %@ </body></html>", dictionary[@"description"]];
        self.RSVPcount = dictionary[@"yes_rsvp_count"];
        self.homePage = [NSURL URLWithString:dictionary[@"event_url"]];
        self.eventID = dictionary[@"id"];

        NSDictionary *venue = dictionary[@"venue"];
        self.location = [NSString stringWithFormat:@"%@\n%@\n%@, %@", venue[@"name"], venue[@"address_1"], venue[@"city"], venue[@"state"]];

        self.memberTitle = dictionary[@"group"][@"who"];
        self.hostingGroup = dictionary[@"group"][@"name"];
        return self;
    }
    return self;
}

+ (void)retrieveMeetups: (NSString *)searchTerm withCompletion:(void(^)(NSArray *meetupEventsArray))complete
{
    NSString *urlString =[NSString stringWithFormat: @"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=61843107c6fc55826453135e261d", searchTerm];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (!connectionError)
         {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSArray *jsonArray = [json objectForKey:@"results"];
             NSMutableArray *tempArray = [NSMutableArray new];
             for (NSDictionary *meetups in jsonArray)
             {
                 MeetupEvent *newEvent = [[MeetupEvent alloc]initWithDictionary:meetups];
                 [tempArray addObject:newEvent];
             }
             complete(tempArray);
         }
     }];
}


@end
