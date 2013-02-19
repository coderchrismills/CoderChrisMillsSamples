//
//  Annotation.m
//  MapFriends
//
//  Created by Richard Mills on 2/8/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import "Annotation.h"
#import "FavoriteLocation.h"
/****************************************************************************/
@implementation Annotation
/****************************************************************************/
- (id)initWithLocation:(FavoriteLocation *)location
{
    self = [super init];
    if(self)
    {
        favoriteLocation = location;
    }
    return self;
}
/****************************************************************************/
- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [[favoriteLocation latitude] floatValue];
    theCoordinate.longitude = [[favoriteLocation longitude] floatValue];
    return theCoordinate; 
}
/****************************************************************************/
- (void)dealloc
{
    favoriteLocation = nil;
}
/****************************************************************************/
- (NSString *)title
{
    return [favoriteLocation locationName];
}
/****************************************************************************/
- (NSString *)subtitle
{
    int score = [[favoriteLocation locationScore] intValue];
    NSString *star = (score > 1) ? @"Stars" : @"Star";
    NSString *score_str = [NSString stringWithFormat:@"%@ %@",[[favoriteLocation locationScore] stringValue], star];
    return score_str;
}
/****************************************************************************/
@end
