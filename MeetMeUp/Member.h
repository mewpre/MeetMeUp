//
//  Member.h
//  MeetMeUp
//
//  Created by Yi-Chin Sun on 1/26/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

@property NSString *name;
@property NSString *memberID;
@property NSString *location;
@property NSData *imageData;
@property NSArray *topics;

- (void)retrieveMemberData: (NSString *)memberID withCompletion:(void(^)(NSArray *topicsArray))complete;

@end
