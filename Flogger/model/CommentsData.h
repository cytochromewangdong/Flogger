//
//  CommentsData.h
//  PageControlExample
//
//  Created by jwchen on 11-12-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommentsData : NSObject {
    NSString *name;
    NSString *content;
    UIImage  *icon;
    UIImage  *videoimg;
    NSString *time;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) UIImage  *icon;
@property (nonatomic, retain) UIImage  *videoimg;
@property (nonatomic, retain) NSString *time;

-(void)set:(NSString*)name:(NSString*)content:(NSString*)time:
           (UIImage*)icon:(UIImage*)videoimg;
-(NSString*)getName;
-(NSString*)getContent;
-(NSString*)getTime;
-(UIImage*)getIcon;
-(UIImage*)getVideoThumbs;

@end
