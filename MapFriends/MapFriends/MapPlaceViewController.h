//
//  MapPlaceViewController.h
//  MapFriends
//
//  Created by Richard Mills on 2/17/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import "ViewController.h"
#import <MapKit/MapKit.h>
/****************************************************************************/
@interface MapPlaceViewController : UIViewController <MKMapViewDelegate>
{
    
}
/****************************************************************************/
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
/****************************************************************************/
- (IBAction)dissmissProfileView:(id)sender;
/****************************************************************************/
+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;
/****************************************************************************/
@end
