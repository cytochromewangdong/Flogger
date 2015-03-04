//
//  FindFriends.h
//  Flogger
//
//  Created by jwchen on 11-12-19.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFriendsIconUrlKey            @"iconurl"
#define kFriendsNameKey            @"name"
#define kFriendsFollowflagKey      @"followflag"


@interface FindFriends : NSObject {
    NSString    *name;
    NSString    *iconurl;
    bool        followflag;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *iconurl;
@property (nonatomic)       bool     followflag;
   
- (FindFriends*)myinit:(NSString *)url:(NSString *)n:(bool)flag;
@end
