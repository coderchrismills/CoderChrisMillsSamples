//
//  FavoriteLocationView.m
//  MapFriends
//
//  Created by Richard Mills on 2/18/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import "FavoriteLocationView.h"
/****************************************************************************/
@implementation FavoriteLocationView
/****************************************************************************/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { }
    return self;
}
/****************************************************************************/
- (void)setLocationWith:(NSString *)name
                  score:(NSNumber *)score
{
    if([name length] < 1)
        [self setHidden:YES];
    [self setHidden:NO];
    [[self locationName] setText:name];
    [[self locationScore] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Stars_%@.png", [score stringValue]]]];
}
/****************************************************************************/
@end
