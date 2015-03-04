//
//  PublicFeedViewController.h
//  Flogger
//
//  Created by jwchen on 12-1-20.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "BaseNetworkViewController.h"
#import "FeedGridPageView.h"
#import "NoMenuProtocol.h"
#import "NoLoginProtocol.h"

@interface PublicFeedViewController : BaseNetworkViewController<NoMenuProtocol, NoLoginProtocol>
{
    BOOL _isFirst;
}
@property(nonatomic, retain) FeedGridPageView *gridPageView;
@end
