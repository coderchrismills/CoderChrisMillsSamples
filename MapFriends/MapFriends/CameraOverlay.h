//
//  CameraOverlay.h
//  MapFriends
//
//  Created by Richard Mills on 2/8/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import <UIKit/UIKit.h>
/****************************************************************************/
@protocol CameraOverlayDelegate
- (void)userOverlayPressed:(int)user_id;
@end
/****************************************************************************/
@interface CameraOverlay : UIView
{
    
}
/****************************************************************************/
@property (nonatomic, weak) id<CameraOverlayDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView *userImage;
@property (nonatomic, strong) NSNumber *locationTag;
/****************************************************************************/
- (IBAction)handleUserPress:(id)sender;
/****************************************************************************/
@end
