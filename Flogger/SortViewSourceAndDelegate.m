//
//  SortViewSourceAndDelegate.m
//  Flogger
//
//  Created by jwchen on 11-12-29.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import "SortViewSourceAndDelegate.h"

@interface SortViewSourceAndDelegate(){
@private
    
    BaseViewController* mview;
}
@end

@implementation SortViewSourceAndDelegate

- (id)init
{
    self = [super init];
    if (self) {
        NSArray *array = [[NSArray alloc] initWithObjects:@"All", @"Photo",
                          @"Video", @"Weibo", @"Activity", nil];
        sorttypes = array;
        [array release];

    }
    return self;
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return [sorttypes count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView
			 titleForRow:(NSInteger)row
			forComponent:(NSInteger)component {
    return [sorttypes objectAtIndex:row];
}


@end
