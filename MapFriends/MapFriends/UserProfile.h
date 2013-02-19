//
//  UserProfile.h
//  MapFriends
//
//  Created by Richard Mills on 2/10/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import <Foundation/Foundation.h>
/****************************************************************************/
@class FavoriteLocation;
/****************************************************************************/
@interface UserProfile : NSObject
{

}
/****************************************************************************/
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *avatarImagePath;
@property (nonatomic, strong) NSString *thumbnailImagePath;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userHandle;
@property (nonatomic, strong) NSMutableArray *favoriteLocations;
/****************************************************************************/
- (id)initWithName:(NSString *)name
        userHandle:(NSString *)handle
            userId:(NSNumber *)userid
        avatarPath:(NSString *)avatarpath
         thumbPath:(NSString *)thumbnailpath;
- (void)addLocation:(FavoriteLocation *)location;
/****************************************************************************/
@end
