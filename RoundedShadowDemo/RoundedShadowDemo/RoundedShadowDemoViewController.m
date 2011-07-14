//
//  RoundedShadowDemoViewController.m
//  Created by Chris Mills on 7/9/11.
//
/****************************************************************************/
#import "RoundedShadowDemoViewController.h"
#import <QuartzCore/QuartzCore.h> // Don't for get this for the shadow properties
/****************************************************************************/
@implementation RoundedShadowDemoViewController
/****************************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
/****************************************************************************/
#pragma mark - View lifecycle
/****************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Let's make a rounded shadow!
	fCurrentCornerRadius	= 8.f;						// Radius for the corner rounding. 
	shadowOffsetSize		= CGSizeMake(-5.f, 5.f);	// x,y shadow offset
	CALayer *iconlayer		= roundedView.layer;		// Get the CALayer that has the shadow properties
	iconlayer.masksToBounds	= NO;						// If yes, our shadow will get cliped. 
	iconlayer.cornerRadius	= fCurrentCornerRadius;						
	iconlayer.shadowOffset	= shadowOffsetSize; 
	iconlayer.shadowRadius	= 5;
	iconlayer.shadowOpacity = 0.6;
}
/****************************************************************************/
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
/****************************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
/****************************************************************************/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
/****************************************************************************/
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
/****************************************************************************/
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
/****************************************************************************/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/****************************************************************************/
#pragma mark - Slider Methods
/****************************************************************************/
-(IBAction)xShadowDidChange:(id)sender
{
	float curval = ((UISlider *)sender).value;
	shadowOffsetSize.width = curval;				// width = x
	roundedView.layer.shadowOffset	= shadowOffsetSize;	

	// Let the view know it needs to be redrawn with the new parameters
	[roundedView setNeedsDisplay];					
}
/****************************************************************************/
-(IBAction)yShadowDidChange:(id)sender
{
	float curval = ((UISlider *)sender).value;
	shadowOffsetSize.height = curval;				// height = y
	roundedView.layer.shadowOffset	= shadowOffsetSize;	
	
	// Let the view know it needs to be redrawn with the new parameters
	[roundedView setNeedsDisplay];					
}
/****************************************************************************/
-(IBAction)radiusDidChange:(id)sender
{
	fCurrentCornerRadius = ((UISlider *)sender).value;
	CALayer *iconlayer		= roundedView.layer;
	iconlayer.cornerRadius	= fCurrentCornerRadius;	
	
	// Let the view know it needs to be redrawn with the new parameters
	[roundedView setNeedsDisplay];					
}
/****************************************************************************/
@end
