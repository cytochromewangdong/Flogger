//
//  FloggerFilterAdapter.h
//  Flogger
//
//  Created by dong wang on 12-3-28.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *NORMAL_FILTER_NAME;
@interface FilterProperty :NSObject
{
    NSString * _title;
}
-(id) initWithName:(NSString*) pname;
@property (assign) float previewQuality;
@property (assign) float extraEffectQuality;
@property (retain) UIImage* border;
@property (retain) NSString* title;
@property (retain) NSString* filter;
@property (retain) NSString* borderImageName;
@property (readonly) NSString* name;
@property (retain) NSString* iconName;
@property  (retain, readonly) UIImage* icon;
-(float) getQualityPrefered:(float) preferedQuality Mode:(BOOL)hasExtra;
@end

@interface FloggerFilterAdapter : NSObject
+(NSString*) getFilterSavePath;
+(FloggerFilterAdapter *)sharedInstance;
+(void)purgeSharedInstance;
-(NSArray*) createFilterList;
-(NSArray*) createBorderList;
-(UIImage*)createTexture:(NSString*)name;
-(NSString*)getFilter:(NSString*)name;
@end
