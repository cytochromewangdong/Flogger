//
//  FindFriendServerProxy.h
//  Flogger
//
//  Created by jwchen on 12-3-15.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseServerProxy.h"
#import "FindFriendCom.h"
#import "IssueInfoCom.h"

@interface FindFriendServerProxy : BaseServerProxy

-(void)findFriendsFromAddressBook:(FindFriendCom *)com;

@end
