//
//  FloggerLayoutManager.h
//  Flogger
//
//  Created by wyf on 12-3-23.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloggerLayoutManager : NSObject

+(FloggerLayoutManager *) screenLayoutManager;
-(CGRect) getLayout : (NSString *) screenName withUI:(NSString *) uiName;

@end
