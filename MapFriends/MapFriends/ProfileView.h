//
//  ProfileView.h
//  MapFriends
//
//  Created by Richard Mills on 2/18/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import <UIKit/UIKit.h>
/****************************************************************************/
@class UserProfile;
@class FavoriteLocationView;
/****************************************************************************/
@interface ProfileView : UIView
{
}
/****************************************************************************/
@property (nonatomic, strong) IBOutlet UILabel *userName;
@property (nonatomic, strong) IBOutlet UILabel *userHandle;
@property (nonatomic, strong) IBOutlet UIImageView *userAvatar;
@property (nonatomic, strong) IBOutlet FavoriteLocationView *favoriteLocation0;
@property (nonatomic, strong) IBOutlet FavoriteLocationView *favoriteLocation1;
@property (nonatomic, strong) IBOutlet FavoriteLocationView *favoriteLocation2;
/****************************************************************************/
- (void)setWithUserInfo:(UserProfile *)profile;
/****************************************************************************/
@end
