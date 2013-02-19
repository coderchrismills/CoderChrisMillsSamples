//
//  MapViewController.h
//  MapFriends
//
//  Created by Richard Mills on 2/8/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
/****************************************************************************/
@interface MapViewController : UIViewController <MKMapViewDelegate>
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
