//
//  ViewController.m
//  MapFriends
//
//  Created by Richard Mills on 2/6/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import "ViewController.h"
#import "PlaceOfInterest.h"
#import "ARView.h"
#import "ProfileView.h"
#import "UserProfile.h"
#import "FavoriteLocation.h"
#import <CoreLocation/CoreLocation.h>
/****************************************************************************/
@interface ViewController ()

@end
/****************************************************************************/
@implementation ViewController
/****************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
	userArray = [[NSMutableArray alloc] init];
    [self generateFakeUserArray];
    
	NSMutableArray *placesOfInterest = [[NSMutableArray alloc] init];
    
    for (UserProfile *p in userArray)
    {
        for (FavoriteLocation *f in [p favoriteLocations])
        {
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CameraOverlay"
                                                          owner:nil
                                                        options:nil];
            if([nibs count])
            {
                id nib = [nibs objectAtIndex:0];
                if([nib isKindOfClass:[CameraOverlay class]])
                {
                    CameraOverlay *v = (CameraOverlay *)nib;
                    [[v userImage] setImage:[UIImage imageNamed:[p thumbnailImagePath]]];
                    [v setLocationTag:[p userId]];
                    [v setDelegate:self];
                    PlaceOfInterest *poi = [PlaceOfInterest placeOfInterestWithView:v at:[[CLLocation alloc] initWithLatitude:[[f latitude] floatValue]
                                                                                                                    longitude:[[f longitude] floatValue]]];
                    [placesOfInterest addObject:poi];
                }
            }
        }
    }
	[[self arView] setPlacesOfInterest:placesOfInterest];
}
/****************************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[self arView] start];
    
    UIApplication *app = [UIApplication sharedApplication];
    if(!app.statusBarHidden)
    {
        [self.view setFrame:CGRectMake(0.0,
                                       app.statusBarFrame.size.height,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height - app.statusBarFrame.size.height)];
    }
}
/****************************************************************************/
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[[self arView] stop];
}
/****************************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/****************************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}
/****************************************************************************/
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
/****************************************************************************/
- (void)userOverlayPressed:(int)user_id
{
    [[self profileView] setWithUserInfo:[userArray objectAtIndex:user_id]];
    [[self profileView] setHidden:NO];
}
/****************************************************************************/
- (IBAction)closeProfile:(id)sender
{
    [[self profileView] setHidden:YES];
}
/****************************************************************************/
- (IBAction)openProfileMap:(id)sender
{
    [self performSegueWithIdentifier:@"ShowMapView" sender:self];
}
/****************************************************************************/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
    if ([[segue identifier] isEqualToString:@"showAbout"])
    {
        UINavigationController *nav = [segue destinationViewController];
        FlipsideViewController *flip = [nav.viewControllers objectAtIndex:0];
        
        [flip setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            [self setCurrentPopoverController:popoverController];
            popoverController.delegate = self;
        }
    }
     */
}
/****************************************************************************/
#pragma mark - fake gen
/****************************************************************************/
- (void)generateFakeUserArray
{
    // This is all just hard coded till i'm downloading from the site
    UserProfile *jodi = [[UserProfile alloc] initWithName:@"Jodi"
                                               userHandle:@"@jodi"
                                                   userId:[NSNumber numberWithInt:0]
                                               avatarPath:@"Avatar_Jodi.png"
                                                thumbPath:@"UserNote_Jodi.png"];
    
    FavoriteLocation *central = [[FavoriteLocation alloc] initWithName:@"Central Park"
                                                                 score:[NSNumber numberWithInt:4]
                                                              latitude:40.7711329
                                                             longitude:-73.9741874
                                                             thumbnail:@"SFIcon.png"];
    
    [jodi addLocation:central];
    [userArray addObject:jodi];
    central = nil;
    jodi    = nil;
    
    UserProfile *jason = [[UserProfile alloc] initWithName:@"Jason"
                                                userHandle:@"@jason"
                                                    userId:[NSNumber numberWithInt:1]
                                                avatarPath:@"Avatar_Jason.png"
                                                 thumbPath:@"UserNote_Jason.png"];
    
    FavoriteLocation *corn = [[FavoriteLocation alloc] initWithName:@"Cornucopia"
                                                              score:[NSNumber numberWithInt:3]
                                                           latitude:44.054403
                                                          longitude:-123.089196
                                                          thumbnail:@"SFIcon.png"];
    [jason addLocation:corn];
    
    FavoriteLocation *pw = [[FavoriteLocation alloc] initWithName:@"Pipeworks"
                                                            score:[NSNumber numberWithInt:5]
                                                         latitude:44.050232
                                                        longitude:-123.094804
                                                        thumbnail:@"SFIcon.png"];
    [jason addLocation:pw];
    [userArray addObject:jason];
    corn    = nil;
    pw      = nil;
    jason   = nil;
    
    UserProfile *chris = [[UserProfile alloc] initWithName:@"Chris"
                                                userHandle:@"@skribbles"
                                                    userId:[NSNumber numberWithInt:2]
                                                avatarPath:@"Avatar_Chris.png"
                                                 thumbPath:@"UserNote_Chris.png"];
    
    FavoriteLocation *ggpark = [[FavoriteLocation alloc] initWithName:@"GG Park"
                                                                score:[NSNumber numberWithInt:5]
                                                             latitude:37.7690400
                                                            longitude:-122.4835193
                                                            thumbnail:@"SFIcon.png"];
    [chris addLocation:ggpark];
    
    FavoriteLocation *home = [[FavoriteLocation alloc] initWithName:@"Home"
                                                              score:[NSNumber numberWithInt:4]
                                                           latitude:44.041916
                                                          longitude:-123.124733
                                                          thumbnail:@"SFIcon.png"];
    [chris addLocation:home];
    [userArray addObject:chris];
    ggpark  = nil;
    home    = nil;
    chris   = nil;
}
/****************************************************************************/
@end
