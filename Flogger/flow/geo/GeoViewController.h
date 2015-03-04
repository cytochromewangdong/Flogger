//
//  GeoViewController.h
//  Flogger
//
//  Created by jwchen on 12-3-2.
//  Copyright (c) 2012年 jwchen. All rights reserved.
//

#import "ClPageViewController.h"

@protocol GeoViewControllerDelegate <NSObject>

-(void)geoLocationSelected:(NSString *)location;

@end

@interface GeoViewController : ClPageViewController <UITextFieldDelegate>

@property(nonatomic, retain) UITextField *keyTf;
@property(nonatomic, assign) id /*<GeoViewControllerDelegate>*/ delegate;
@property(nonatomic, retain) NSTimer *timer;
@end
