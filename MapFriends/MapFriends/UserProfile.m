//
//  UserProfile.m
//  MapFriends
//
//  Created by Richard Mills on 2/10/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import "UserProfile.h"
/****************************************************************************/
@implementation UserProfile
/****************************************************************************/
- (id)init
{
    self  = [super init];
    if(self)
    {
        [self setUserName:@""];
        [self setUserHandle:@""];
        [self setUserId:[NSNumber numberWithInt:-1]];
        [self setAvatarImagePath:@"Avatar.png"];
        [self setThumbnailImagePath:@"UserNote.png"];
        [self setFavoriteLocations:[@[] mutableCopy]];
    }
    return self;
}
/****************************************************************************/
- (id)initWithName:(NSString *)name
        userHandle:(NSString *)handle
            userId:(NSNumber *)userid
        avatarPath:(NSString *)avatarpath
         thumbPath:(NSString *)thumbnailpath
{
    self = [super init];
    if(self)
    {
        [self setUserName:name];
        [self setUserHandle:handle];
        [self setUserId:userid];
        [self setAvatarImagePath:avatarpath];
        [self setThumbnailImagePath:thumbnailpath];
        [self setFavoriteLocations:[@[] mutableCopy]];
    }
    return self;
}
/****************************************************************************/
- (void)addLocation:(FavoriteLocation *)location
{
    [[self favoriteLocations] addObject:location];
}
/****************************************************************************/
@end
