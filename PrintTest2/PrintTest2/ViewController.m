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
    pdfPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.pdf", (int)[[NSDate date] timeIntervalSince1970]]];
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
    WebPopOverViewController *vc = (WebPopOverViewController *)[segue destinationViewController];
    [vc setPdfFilePath:pdfPath];
}
/****************************************************************************/
@end
