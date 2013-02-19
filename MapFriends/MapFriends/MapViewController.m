//
//  MapViewController.m
//  MapFriends
//
//  Created by Richard Mills on 2/8/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import "MapViewController.h"
#import "Annotation.h"
#import "FavoriteLocation.h"
/****************************************************************************/
@interface MapViewController ()

@end
/****************************************************************************/
enum
{
    kCityAnnotationIndex = 0,
    kBridgeAnnotationIndex
};
/****************************************************************************/
@implementation MapViewController
/****************************************************************************/
#pragma mark - static methods
/****************************************************************************/
+ (CGFloat)annotationPadding { return 10.0f; }
/****************************************************************************/
+ (CGFloat)calloutHeight { return 40.0f; }
/****************************************************************************/
- (void)gotoLocation
{
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 44.0522;
    newRegion.center.longitude = -123.0856;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    [self.mapView setRegion:newRegion animated:YES];
}
/****************************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}
/****************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [[self mapView] setDelegate:self];
    [[self mapView] setMapType:MKMapTypeStandard];
    
    // create out annotations array (in this example only 2)
    self.mapAnnotations = [[NSMutableArray alloc] init];
    
    FavoriteLocation *location = [[FavoriteLocation alloc] initWithName:@"Home"
                                                                  score:[NSNumber numberWithInt:4]
                                                               latitude:44.04192
                                                              longitude:-123.12473
                                                              thumbnail:@"SFIcon.png"];
    Annotation *slannotation = [[Annotation alloc] initWithLocation:location];
    [[self mapAnnotations] addObject:slannotation];
    
    [self gotoLocation];
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    
    [self.mapView addAnnotations:self.mapAnnotations];
}
/****************************************************************************/
- (void)viewDidAppear:(BOOL)animated
{
    // bring back the toolbar
    //[self.navigationController setToolbarHidden:YES animated:NO];
    [super viewDidAppear:animated];
}
/****************************************************************************/
- (void)dealloc
{
    self.mapAnnotations = nil;
    self.mapView = nil;
}
/****************************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/****************************************************************************/
- (IBAction)dissmissProfileView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/****************************************************************************/
#pragma mark - MKMapViewDelegate
/****************************************************************************/
- (void)showDetails:(id)sender
{
    // the detail view does not want a toolbar so hide it
    //[self.navigationController setToolbarHidden:YES animated:NO];
}
/****************************************************************************/
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[Annotation class]])   // for City of San Francisco
    {
        static NSString* SFAnnotationIdentifier = @"AnnotationIdentifier";
        MKPinAnnotationView* pinView =
        (MKPinAnnotationView *)[[self mapView] dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
        if (!pinView)
        {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                            reuseIdentifier:SFAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            
            UIImage *flagImage = [UIImage imageNamed:@"flag.png"];
            
            CGRect resizeRect;
            
            resizeRect.size = flagImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [flagImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image = resizedImage;
            annotationView.opaque = NO;
            
            UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
            annotationView.leftCalloutAccessoryView = sfIconView;
            
            return annotationView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}
/****************************************************************************/
@end
