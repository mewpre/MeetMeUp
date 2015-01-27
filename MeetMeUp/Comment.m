//
//  Comment.m
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "Comment.h"
#import "Member.h"

@implementation Comment


-(instancetype)initWithDictionary: (NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        //Xcode uses seconds since epoch while Meetup API uses milliseconds
        double time = [dictionary[@"time"] doubleValue] /1000;
        self.commentDate = [NSDate dateWithTimeIntervalSince1970:time];
        self.comment = dictionary[@"comment"];
        self.member = [Member new];
        self.member.memberID = dictionary[@"member_id"];
        self.member.name = dictionary[@"member_name"];
    }
    return self;
}

+ (void)retrieveComments: (NSString *)eventID withCompletion:(void(^)(NSArray *commentsArray))complete
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=%@&page=20&key=61843107c6fc55826453135e261d", eventID];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (!connectionError)
         {
             NSMutableArray *tempArray = [NSMutableArray new];
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSArray *jsonArray = [json objectForKey:@"results"];
             for (NSDictionary *comments in jsonArray)
             {
                 Comment *newComment = [[Comment alloc]initWithDictionary:comments];
                 [tempArray addObject:newComment];
             }
             complete(tempArray);
         }
     }];
}

@end
