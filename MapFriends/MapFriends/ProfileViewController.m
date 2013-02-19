//
//  ProfileViewController.m
//  MapFriends
//
//  Created by Richard Mills on 2/9/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import "ProfileViewController.h"
/****************************************************************************/
@interface ProfileViewController ()

@end
/****************************************************************************/
@implementation ProfileViewController
/****************************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { }
    return self;
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
- (IBAction)dissmissProfileView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/****************************************************************************/
@end
