//
//  ViewerHeaderCell.m
//  Flogger
//
//  Created by dong wang on 12-4-7.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ViewerCell.h"
#import "GlobalUtils.h"

@implementation ViewerCell
/*-(FloggerWebView*)createMainWebView
 {
 return  [[FloggerWebAdapter getSingleton]createViewerView:self.action];
 }*/

-(void) fillDataToCell
{
    NSMutableDictionary *mydata = [[[NSMutableDictionary alloc]initWithDictionary:self.issueInfo.dataDict]autorelease];
    //    NSString *timeFormat = [GlobalUtils getDisplayableStrFromDate:[NSDate dateWithTimeIntervalSince1970:[self.issueInfo.createdate longLongValue]/1000]];
    NSString *timeFormat;
    if (self.issueInfo.createdate) {
        if ([self.issueInfo.issuecategory intValue]!=1 && [self.issueInfo.issuecategory intValue]!=2){
            timeFormat = [GlobalUtils getDisplayableStrFromDateForComment:[NSDate dateWithTimeIntervalSince1970:[self.issueInfo.createdate longLongValue]/1000]];
        } else {
            timeFormat = [GlobalUtils getDisplayableStrFromDate:[NSDate dateWithTimeIntervalSince1970:[self.issueInfo.createdate longLongValue]/1000]];
        }
    }else {
        timeFormat = @"--";
    }
    
    [mydata setObject:timeFormat forKey:@"time"];
    
    
    [mydata setObject:[GlobalUtils displayableStrFromVideoduration:[self.issueInfo.videoduration intValue]] forKey:@"videoTime"];
    
    // dispatch_async(dispatch_get_main_queue(), ^{
    [[FloggerLayoutAdapter sharedInstance] fillAndLayoutSubviews:self.mainview ViewDisplayParameters:[FeedViewCell createParamFromIssueInfo:self.issueInfo ExtraParam:self.extraParam] DataFillParameters:mydata InvisibleViews:[FeedViewCell createInvisibleList:self.issueInfo  ExtraParam:self.extraParam]];
    [self delayset];
    
    //   [self setNeedsDisplay];
    //}); 
}
@end
