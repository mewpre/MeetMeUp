//
//  Comment.h
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/19/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Member;

@interface Comment : NSObject

@property NSString *comment;
@property NSDate *commentDate;
@property Member *member;

-(instancetype)initWithDictionary: (NSDictionary *)dictionary;
+ (void)retrieveComments: (NSString *)eventID withCompletion:(void(^)(NSArray *commentsArray))complete;


@end
