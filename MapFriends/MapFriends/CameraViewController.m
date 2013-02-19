//
//  CameraViewController.m
//  MapFriends
//
//  Created by Richard Mills on 2/8/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import "CameraViewController.h"
/****************************************************************************/
@interface CameraViewController ()

@end
/****************************************************************************/
@implementation CameraViewController
/****************************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
}
/****************************************************************************/
- (void)setupViewController
{
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
	self.showsCameraControls = NO;
    self.navigationBarHidden = YES;
    self.toolbarHidden = YES;
    self.wantsFullScreenLayout = YES;
    CGFloat camScaleup = 1.29;
    self.cameraViewTransform = CGAffineTransformScale(self.cameraViewTransform, camScaleup, camScaleup);
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.allowsEditing = NO;
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CameraOverlay"
                                                  owner:nil
                                                options:nil];
    if([nibs count])
    {
        id nib = [nibs objectAtIndex:0];
        if([nib isKindOfClass:[CameraOverlay class]])
        {
            CameraOverlay *v = (CameraOverlay *)nib;
            [v setDelegate:self];
            [self.cameraOverlayView addSubview:v];
        }
    }
}
/****************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
/****************************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/****************************************************************************/
- (void)userOverlayPressed:(int)user_id
{
    [self performSegueWithIdentifier:@"ShowProfile" sender:self];
}
/****************************************************************************/
@end
