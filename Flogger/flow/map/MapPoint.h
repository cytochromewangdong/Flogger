//
//  MapPoint.h
//  TingJing2
//
//  Created by jwchen on 11-10-24.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface MapPoint : NSObject <MKAnnotation> 
{
    NSString *title;
    NSString *subTitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subTitle;

-(id) initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *) t subTitle:(NSString *) st;


@end
