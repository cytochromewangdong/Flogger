//
//  FeedList.h
//  Flogger
//
//  Created by jwchen on 12-1-10.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "PageModel.h"

#define kIType @"type"

typedef enum 
{
    FEED_FOLLOWING = 1,
    FEED_FEATURED
}FeedType;

@interface FeedList : PageModel
//@property(nonatomic, assign) FeedType feedType;
@end
