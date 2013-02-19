//
//  Annotation.h
//  MapFriends
//
//  Created by Richard Mills on 2/8/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import <MapKit/MapKit.h>
/****************************************************************************/
@class FavoriteLocation;
/****************************************************************************/
@interface Annotation : NSObject <MKAnnotation>
{
    FavoriteLocation *favoriteLocation;
}
/****************************************************************************/
- (id)initWithLocation:(FavoriteLocation *)location;
/****************************************************************************/
@end


