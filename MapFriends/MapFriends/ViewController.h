//
//  ViewController.h
//  MapFriends
//
//  Created by Richard Mills on 2/6/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import <UIKit/UIKit.h>
#import "CameraOverlay.h"
/****************************************************************************/
@class CameraViewController;
@class ARView;
@class UserProfile;
@class ProfileView;
/****************************************************************************/
@interface ViewController : UIViewController <CameraOverlayDelegate>
{
    UIImagePickerController *imagePickerController;
    NSMutableArray *userArray; // Tmp user array until we fill from web.
}
/****************************************************************************/
@property (nonatomic, strong) IBOutlet ProfileView *profileView;
@property (nonatomic, strong) IBOutlet ARView *arView;
/****************************************************************************/
- (IBAction)closeProfile:(id)sender;
- (IBAction)openProfileMap:(id)sender;
/****************************************************************************/
@end
