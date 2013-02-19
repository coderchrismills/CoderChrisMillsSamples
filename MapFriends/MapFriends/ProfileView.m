//
//  ProfileView.m
//  MapFriends
//
//  Created by Richard Mills on 2/18/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import "ProfileView.h"
#import "UserProfile.h"
#import "FavoriteLocation.h"
#import "FavoriteLocationView.h"
/****************************************************************************/
@implementation ProfileView
/****************************************************************************/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { }
    return self;
}
/****************************************************************************/
- (void)setWithUserInfo:(UserProfile *)profile
{
    [[self userName] setText:[profile userName]];
    [[self userHandle] setText:[profile userHandle]];
    [[self userAvatar] setImage:[UIImage imageNamed:[profile avatarImagePath]]];
    
    // Let the hacks continue! Again. When the web is hooked up, this goes away
    int num_locations = [[profile favoriteLocations] count];
    [[self favoriteLocation0] setHidden:num_locations < 1];
    [[self favoriteLocation1] setHidden:num_locations < 2];
    [[self favoriteLocation2] setHidden:num_locations < 3];
    if(num_locations > 0)
    {
        FavoriteLocation *f = [[profile favoriteLocations] objectAtIndex:0];
        [[self favoriteLocation0] setLocationWith:[f locationName]
                                            score:[f locationScore]];
    }
    if(num_locations > 1)
    {
        FavoriteLocation *f = [[profile favoriteLocations] objectAtIndex:1];
        [[self favoriteLocation1] setLocationWith:[f locationName]
                                            score:[f locationScore]];
    }
    if(num_locations > 2)
    {
        FavoriteLocation *f = [[profile favoriteLocations] objectAtIndex:2];
        [[self favoriteLocation2] setLocationWith:[f locationName]
                                            score:[f locationScore]];
    }
}
/****************************************************************************/
@end
