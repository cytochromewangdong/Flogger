//
//  MapViewController.h
//  TingJing2
//
//  Created by jwchen on 11-10-24.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPoint.h"

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic, retain) MKMapView *mapView;
@property(nonatomic, retain) MapPoint *mapPoint;
@end
