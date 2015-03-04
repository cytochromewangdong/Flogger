//
//  FloggerNavButtonsHelper.h
//  Flogger
//
//  Created by steveli on 10/08/2012.
//  Copyright (c) 2012 atoato. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define kTwoLeftButton				1234
//#define kTwoRightButton				1235
#define kTwoView				1234
#define kLable				1234
@interface FloggerNavButtonsHelper : NSObject
+(void)addNavTwoButton: (UINavigationBar *)navigationBar leftBtton:(UIButton *)leftBtton rightButton:(UIButton *)rightButton ;
@end
