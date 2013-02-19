//
//  CameraOverlay.m
//  MapFriends
//
//  Created by Richard Mills on 2/8/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import "CameraOverlay.h"
/****************************************************************************/
@implementation CameraOverlay
/****************************************************************************/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { }
    return self;
}
/****************************************************************************/
- (IBAction)handleUserPress:(id)sender
{
    [[self delegate] userOverlayPressed:[[self locationTag] intValue]];
}
/****************************************************************************/
@end
