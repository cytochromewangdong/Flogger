//
//  SortViewSourceAndDelegate.h
//  Flogger
//
//  Created by jwchen on 11-12-29.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"


@interface SortViewSourceAndDelegate : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>  {
    NSArray *sorttypes;
}

-(void)bindMainView:(BaseViewController*)view;
-(BaseViewController*)getMainView;

@end
