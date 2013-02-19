//
//  CameraViewController.h
//  MapFriends
//
//  Created by Richard Mills on 2/8/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import <UIKit/UIKit.h>
#import "CameraOverlay.h"
/****************************************************************************/
@interface CameraViewController : UIImagePickerController <CameraOverlayDelegate>
{
}
/****************************************************************************/
- (void)setupViewController;
/****************************************************************************/
@end
