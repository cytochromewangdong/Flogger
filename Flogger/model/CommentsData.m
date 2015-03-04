//
//  CommentsData.m
//  PageControlExample
//
//  Created by jwchen on 11-12-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommentsData.h"


@implementation CommentsData

@synthesize name,content,icon,videoimg,time;

-(id)init{
    if ((self = [super init])) {
        
    }
    return self;
}

- (void)dealloc {
    [name release];
    [content release];
    [icon release];
    [videoimg release];
    [time release];
    [super dealloc];
}

-(void)set:(NSString*)name:(NSString*)content:(NSString*)time:
(UIImage*)img:(UIImage*)videoimg
{
    self.name = name;
    self.content = content;
    self.time = time;
    self.icon = img;
    self.videoimg = videoimg;
}
-(NSString*)getName
{
    return name;
}
-(NSString*)getContent
{
    return content;
}
-(NSString*)getTime
{
    return time;
}
-(UIImage*)getIcon
{
    return icon;
}
-(UIImage*)getVideoThumbs
{
    return videoimg;
}

@end
