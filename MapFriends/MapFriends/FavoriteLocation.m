//
//  FavoriteLocation.m
//  MapFriends
//
//  Created by Richard Mills on 2/10/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import "FavoriteLocation.h"
#import <MapKit/MapKit.h>
/****************************************************************************/
@implementation FavoriteLocation
/****************************************************************************/
- (id)initWithName:(NSString *)name
             score:(NSNumber *)score
          latitude:(CGFloat)lat
         longitude:(CGFloat)lon
         thumbnail:(NSString *)path
{
    self = [super init];
    if(self)
    {
        [self setLocationName:name];
        [self setLocationScore:score];
        [self setLatitude:[NSNumber numberWithFloat:lat]];
        [self setLongitude:[NSNumber numberWithFloat:lon]];
        [self setImage:[UIImage imageNamed:path]];
    }
    return self;
}
/****************************************************************************/
@end
