//
//  LocationManager.h
//  TingJing2
//
//  Created by jwchen on 11-9-27.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class LocationManager;
@protocol LocationManagerDelegate <NSObject>
-(void)locationManager:(LocationManager *)locationManager didUpdateToLocation:(CLLocation *)location;
@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
    NSTimer * timer;
}

+(LocationManager *)sharedInstance;

+(void)purgeSharedInstance;

@property(nonatomic, assign) id/*<LocationManagerDelegate>*/ delegate;

@property(nonatomic, retain) CLLocation *currentLocation;
@property(nonatomic, assign) NSTimeInterval lastKnownLocationTime;
@property(nonatomic, retain) CLLocationManager *locationManager;
-(void)startUpdatingLocation;

-(void)startUpdatingLocationWithDelegate:(id)delegate;

-(void)stopUpdatingLocation;

-(void)updateLocationAccuracy:(CLLocationAccuracy) accuracy;

-(void) startGetLocation;
@end
