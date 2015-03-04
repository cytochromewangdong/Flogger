//
//  main.m
//  Flogger
//
//  Created by jwchen on 11-12-26.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FloggerAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([FloggerAppDelegate class]));
    [pool release];
    return retVal;
    /*@autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([FloggerAppDelegate class]));
    }*/
}
