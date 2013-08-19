//
//  WebPopOverViewController.m
//  PrintTest2
//
//  Created by Richard Mills on 8/18/13.
//  Copyright (c) 2013 Happy Maau Studios, LLC. All rights reserved.
//
/****************************************************************************/
#import "WebPopOverViewController.h"
/****************************************************************************/
@interface WebPopOverViewController ()
{
    BNHtmlPdfKit *htmlPdfKit;
    NSString *htmlString;
}
@end
/****************************************************************************/
@implementation WebPopOverViewController
/****************************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/****************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    htmlPdfKit = [[BNHtmlPdfKit alloc] init];
    htmlPdfKit.delegate = self;
    
    htmlString = @"<html><head></head><body><h2>Instructions</h2><p>Tap the Action button to mail with UIActivity. Press Compose to bring up the MFMailCompose</p>";
    [[self webView] loadHTMLString:htmlString
                           baseURL:[[NSBundle mainBundle] bundleURL]];
    
    [[self composeButton] setEnabled:NO];
    [[self actionButton] setEnabled:NO];
    
    [htmlPdfKit saveHtmlAsPdf:htmlString
                       toFile:[self pdfFilePath]
                       inView:self.view];
}
/****************************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/****************************************************************************/
#pragma mark - Button Events
/****************************************************************************/
- (IBAction)donePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/****************************************************************************/
- (IBAction)composePressed:(id)sender
{
    // email the PDF File.
	MFMailComposeViewController* mailComposer = [[MFMailComposeViewController alloc] init];
	mailComposer.mailComposeDelegate = self;
	[mailComposer addAttachmentData:[NSData dataWithContentsOfFile:[self pdfFilePath]]
						   mimeType:@"application/pdf"
                           fileName:@"site.pdf"];
	
	[self presentViewController:mailComposer animated:YES completion:nil];
}
/****************************************************************************/
- (IBAction)actionPressed:(id)sender
{
    NSArray *activityItems = @[[NSData dataWithContentsOfFile:[self pdfFilePath]]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}
/****************************************************************************/
#pragma mark - MFMailComposerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/****************************************************************************/
#pragma mark - UIWebViewDelegate Methods
/****************************************************************************/
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
/****************************************************************************/
#pragma mark - BNHtmlPdfKitDelegate Methods
/****************************************************************************/
- (void)htmlPdfKit:(BNHtmlPdfKit *)htmlPdfKit didSavePdfFile:(NSString *)file
{
    [[self composeButton] setEnabled:YES];
    [[self actionButton] setEnabled:YES];
}
/****************************************************************************/
@end
