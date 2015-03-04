//
//  FloggerServerManage.h
//  FloggerVideo
//
//  Created by wyf on 12-1-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FloggerServerDelegate <NSObject>
@optional 
-(void) setFilterButtonFromServer : (NSMutableDictionary *) filter;
-(void) setTextureImage : (NSMutableArray *) imageArray;
//-(void) 
@end

@interface FloggerServerManage : NSObject
{
    NSObject<FloggerServerDelegate> *_serverDelegate;
    NSMutableArray *_imageArray;
}
+(NSString*) getImageSavePath;
+(NSString*) getMediaSavePath;
@property (assign, nonatomic) NSObject<FloggerServerDelegate> *serverDelegate;
@property (retain, nonatomic) NSMutableDictionary *filterDic;
@property (assign) BOOL finishLoad;
-(void) retrieveFilter;
-(void)uploadData:(NSData *)data withType: (int) type;

@end


