//
//  FindFriends.m
//  Flogger
//
//  Created by jwchen on 11-12-19.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import "FindFriends.h"



@implementation FindFriends
@synthesize iconurl;
@synthesize name;
@synthesize followflag;

- (void)dealloc{
    [name release];
    [iconurl release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:kFriendsNameKey];
    [coder encodeObject:self.iconurl forKey:kFriendsIconUrlKey];
    [coder encodeBool:self.followflag forKey:kFriendsFollowflagKey];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self == [super init]) {
        followflag = [coder decodeBoolForKey:kFriendsFollowflagKey];
        name = [[coder decodeObjectForKey:kFriendsNameKey] retain];
        iconurl = [[coder decodeObjectForKey:kFriendsIconUrlKey] retain];
    }
    return self;
}

- (FindFriends*)myinit:(NSString *)url:(NSString *)n:(bool)flag {
    if (self == [super init]) {
        followflag = flag;
        self.name = n;
        self.iconurl = url;
    }
    return self;
}

- (id)init:(NSString *)url and:(NSString *)n and:(bool)flag {
    if (self == [super init]) {
        followflag = flag;
        self.name = n;
        self.iconurl = url;
    }
    return self;
}

@end
