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
    
    // html we're going to load. Just some instructions on how to use the app
    htmlString = @"<html><head></head><body><h2>Instructions</h2><p>Tap the Action button to mail with UIActivity. Press Compose to bring up the MFMailCompose</p>";
    [[self webView] loadHTMLString:htmlString
                           baseURL:[[NSBundle mainBundle] bundleURL]];
    
    // Disable the sharing buttons till the pdf has been generated
    [[self composeButton] setEnabled:NO];
    [[self actionButton] setEnabled:NO];
    
    // make a view to store the webview that is used in the pdf generation in.
    // If we don't add the webview to this view, the UIWebView callbacks in
    // BNHtmlPdfKit will never fire.
    UIView *v = [[UIView alloc] init];
    [v setHidden:YES];
    [self.view addSubview:v];
    
    // Generate the pdf. 
    [htmlPdfKit saveHtmlAsPdf:htmlString
                       toFile:[self pdfFilePath]];

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
    // email the PDF File using the MFMailComposer. Just be sure to specify the mime type as pdf.
	MFMailComposeViewController* mailComposer = [[MFMailComposeViewController alloc] init];
	mailComposer.mailComposeDelegate = self;
	[mailComposer addAttachmentData:[NSData dataWithContentsOfFile:[self pdfFilePath]]
						   mimeType:@"application/pdf"
                           fileName:@"site.pdf"];   // This is the file name the user will see.
	
	[self presentViewController:mailComposer animated:YES completion:nil];
}
/****************************************************************************/
- (IBAction)actionPressed:(id)sender
{
    // Let the OS handle the sharing for us. Gives the user more flexibility and is pretty rad.
    // Just need to set the activity items array to a single element with the pdf.
    // The OS has the rest really. 
    NSArray *activityItems = @[[NSData dataWithContentsOfFile:[self pdfFilePath]]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                                         applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:NULL];
}
/****************************************************************************/
#pragma mark - MFMailComposerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // This way when the user is done with the email, whether it sends or not, we can
    // remove the mail popover from the view. 
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
    // pdf was made OK. Sweet! Enable the buttons and let people share.
    [[self composeButton] setEnabled:YES];
    [[self actionButton] setEnabled:YES];
}
/****************************************************************************/
@end
