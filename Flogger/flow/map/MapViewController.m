//
//  MapViewController.m
//  TingJing2
//
//  Created by jwchen on 11-10-24.
//  Copyright (c) 2011年 jwchen. All rights reserved.
//

#import "MapViewController.h"
#import "MapPoint.h"

@implementation MapViewController
@synthesize mapView, mapPoint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning]; 
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) backAction : (id) sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)adjustMapViewLayout
{
    self.wantsFullScreenLayout = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    UIView *view = [[FloggerUIFactory uiFactory] createBackgroundView];
    view.frame = CGRectMake(0, 0, 320, 480);
    self.view = view;    
    
    self.mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame = CGRectMake(0, 420, 50, 30);
//    [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
    UIToolbar *toolBar = [[[UIToolbar alloc] init] autorelease];
    toolBar.frame = CGRectMake(0, 0, 320, 44);
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *backItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back") style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)]autorelease];
    
    toolBar.items = [NSArray arrayWithObjects:backItem, nil];
    
    [self.view addSubview:toolBar];
    

}

-(void) loadView
{
    [self adjustMapViewLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView addAnnotation:self.mapPoint];
    
    [self.mapView setCenterCoordinate:self.mapPoint.coordinate];
    
    double latitudinalMeters = 1000;
    double longitudinalMeters = 1000;
    if (![GlobalUtils checkIOS_6]) {
        latitudinalMeters = 500;
        longitudinalMeters = 500;
    }
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([self.mapPoint coordinate] ,latitudinalMeters,longitudinalMeters);
    [self.mapView setRegion:region animated:YES];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.mapView setShowsUserLocation:YES];
//    [self.mapView addAnnotation:self.mapPoint];
//    
//    [self.mapView setCenterCoordinate:self.mapPoint.coordinate];
//    
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([self.mapPoint coordinate] ,500,500);
//    [self.mapView setRegion:region animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{
    self.mapView = nil;
    self.mapPoint = nil;
    [super dealloc];
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{    
    
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
//    NSLog(@"calloutAccessoryControlTapped");
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[MapPoint class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier] autorelease];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [rightButton addTarget:self
//                            action:@selector(showDetails:)
//                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
       return nil;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
//    id annotation = view.annotation;
//    NSLog(@"....");
}

@end
