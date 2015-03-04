//
//  LocationManager.m
//  TingJing2
//
//  Created by jwchen on 11-9-27.
//  Copyright 2011年 jwchen. All rights reserved.
//

#import "LocationManager.h"

static LocationManager *instance;

@implementation LocationManager
@synthesize currentLocation, locationManager, lastKnownLocationTime, delegate;

#define kMaxTime 60*2.0

+(LocationManager *)sharedInstance
{
    if (!instance) {
        instance = [[LocationManager alloc] init];
//        NSLog(@"new location instance");
    }
    
    return instance;
}

+(void)purgeSharedInstance
{
    [instance release];
    instance = nil;
}


//SYNTHESIZE_SINGLETON_FOR_CLASS(LocationManager);

- (id)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;//kCLLocationAccuracyKilometer;
    }
    
    return self;
}

-(void) startGetLocation
{
    [self currentLocation];
    timer = [[NSTimer scheduledTimerWithTimeInterval:kMaxTime target:self selector:@selector(currentLocation) userInfo:nil repeats:YES]retain];
    //[timer fire];
    

}
-(void)updateLocationAccuracy:(CLLocationAccuracy) accuracy
{
    self.locationManager.desiredAccuracy = accuracy;
}

-(void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

-(void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

-(void)startUpdatingLocationWithDelegate:(id)delegate
{
    self.delegate = self;
    [self startUpdatingLocation];
}

-(void)dealloc
{
    [locationManager stopUpdatingLocation];
    [timer invalidate];
    [timer release];
    self.locationManager = nil;
    self.currentLocation = nil;
    [super dealloc];
}

#pragma mark location update delegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"location updated: %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    self.currentLocation = newLocation;
    self.lastKnownLocationTime = [[NSDate date] timeIntervalSince1970];
    [self stopUpdatingLocation];
}

-(CLLocation *)currentLocation
{
    //NSLog(@"===========%f",([[NSDate date] timeIntervalSince1970] - lastKnownLocationTime)); 
    if ([[NSDate date] timeIntervalSince1970] - lastKnownLocationTime > kMaxTime || !currentLocation) {
        [self startUpdatingLocation];
    }
    return currentLocation;
}

@end
