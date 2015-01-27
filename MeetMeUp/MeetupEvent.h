//
//  MeetupEvent.h
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeetupEvent : NSObject

@property NSString *name;
@property NSString *hostingGroup;
@property NSString *HTMLDescription;
@property NSString *location;
@property NSString *RSVPcount;
@property NSURL *homePage;
@property NSString *eventID;
@property NSString *memberTitle;
@property NSArray *commentsArray;

+ (void)retrieveMeetups: (NSString *)searchTerm withCompletion:(void(^)(NSArray *meetupEventsArray))complete;

@end
