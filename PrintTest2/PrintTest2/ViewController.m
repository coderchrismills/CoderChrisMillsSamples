//
//  ViewController.m
//  PrintTest2
//
//  Created by Chris Mills on 8/18/13.
//  Copyright (c) 2013 Happy Maau Studios, LLC. All rights reserved.
//
/****************************************************************************/
#import "ViewController.h"
#import "WebPopOverViewController.h"
/****************************************************************************/
@interface ViewController ()
{
    NSString *pdfPath;
}
@end
/****************************************************************************/
@implementation ViewController
/****************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Get a temporary directory to store the PDF we're going to generate.
    // Use the date to get a hopefully unique filename.
    pdfPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.pdf", (int)[[NSDate date] timeIntervalSince1970]]];
    
    // Show the file path with name to the user.
    [[self fileLabel] setText:pdfPath];
}
/****************************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/****************************************************************************/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass the file path off to the pop over.
    WebPopOverViewController *vc = (WebPopOverViewController *)[segue destinationViewController];
    [vc setPdfFilePath:pdfPath];
}
/****************************************************************************/
@end
