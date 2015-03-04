//
//  FloggerRenderAdapter.h
//  Flogger
//
//  Created by wyf on 12-4-5.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenGLRenderCenter.h"
#import "FloggerVideoWriteManage.h"
#import "FloggerFilterAdapter.h"

#define kBackgroundSyntaxParam @"backgroundSyntaxParam"

@interface FloggerRenderAdapter : NSOperation
{
    UIImageOrientation _videoOrientation;;
}
@property (retain, nonatomic) FloggerVideoWriteManage *writeManage;
@property (retain, nonatomic) FilterProperty* currentFilter;
@property (retain, nonatomic) FilterProperty* currentBorder;
@property (retain, nonatomic) AVAssetReader *videoReader;
@property (retain, nonatomic) AVAssetReader *audioReader;
@property (assign, nonatomic) BOOL cancelling;

+(FloggerRenderAdapter *) getRenderAdapter;
-(OpenGLRenderCenter *) createBackgroundRender : (NSString *) normalXml;
-(void) transformVideo : (NSMutableDictionary *) info;
-(void) cancelWriteFile;


@end
