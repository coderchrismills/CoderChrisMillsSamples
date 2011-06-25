//
//  PrintTestViewController.m
//  PrintTest
//
//  Created by Chris Mills on 6/24/11.
//
/****************************************************************************/
#import "PrintTestViewController.h"
/****************************************************************************/
#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kMargin 50
/****************************************************************************/
@implementation PrintTestViewController
/****************************************************************************/
@synthesize printContentWebView;
@synthesize pdfPath;
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
	// Do any additional setup after loading the view, typically from a nib.
	
	/*
	 // Easy to load our own html, rather than loading an external page.
	 NSString *html = @"<html><body>foo</body></html>";
	 [printContentWebView loadHTMLString:html baseURL:nil];
	 */
	[printContentWebView setDelegate:self];
	NSURL *url = [NSURL URLWithString:@"http://happymaau.com/2011/05/17/weekly-update-2/"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[printContentWebView loadRequest:request];
	
	pdfPath = [[NSString alloc] initWithString:@"file://"];

}
/****************************************************************************/
- (void)viewDidUnload
{
	[self setPrintContentWebView:nil];
	[self setPdfPath:nil];
	
    [super viewDidUnload];
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
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
/****************************************************************************/
- (void)dealloc {
	[printContentWebView release];
	[pdfPath release];
	[super dealloc];
}
/****************************************************************************/
#pragma mark - UIWebViewDelegate Methods
/****************************************************************************/
-(void)webViewDidFinishLoad:(UIWebView *)webView 
{
	/* 
		Idea and partial code from : http://itsbrent.net/2011/06/printing-converting-uiwebview-to-pdf/
		Credit where credit's due.
	 */
	
	// Store off the original frame so we can reset it when we're done
	CGRect origframe = webView.frame;
    NSString *heightStr = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"]; // Get the height of our webView
    int height = [heightStr intValue];

	// Size of the view in the pdf page
    CGFloat maxHeight	= kDefaultPageHeight - 2*kMargin;
	CGFloat maxWidth	= kDefaultPageWidth - 2*kMargin;
	int pages = ceil(height / maxHeight);
	
	[webView setFrame:CGRectMake(0.f, 0.f, maxWidth, maxHeight)];
	
	// Normally we'd want a temp directory and a unique file name, but I want to see the final pdf from Simulator
	//NSString *path = NSTemporaryDirectory();
	//self.pdfPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.pdf", [[NSDate date] timeIntervalSince1970] ]];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *path = [paths objectAtIndex:0]; 
    self.pdfPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp.pdf"]];
	
	// Set up we the pdf we're going to be generating is
	UIGraphicsBeginPDFContextToFile(self.pdfPath, CGRectZero, nil);
	int i = 0;
	for ( ; i < pages; i++) 
	{
		// Specify the size of the pdf page
		UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
		// Move the context for the margins
        CGContextTranslateCTM(currentContext, kMargin, kMargin);
		// offset the webview content so we're drawing the part of the webview for the current page
        [[[webView subviews] lastObject] setContentOffset:CGPointMake(0, maxHeight * i) animated:NO];
		// draw the layer to the pdf, ignore the "renderInContext not found" warning. 
        [webView.layer renderInContext:currentContext];
    }
	// all done with making the pdf
    UIGraphicsEndPDFContext();
	// Restore the webview and move it to the top. 
	[webView setFrame:origframe];
	[[[webView subviews] lastObject] setContentOffset:CGPointMake(0, 0) animated:NO];
}
/****************************************************************************/
// From Print WebView Example
/****************************************************************************/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	// report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
							 error.localizedDescription];
	[self.printContentWebView loadHTMLString:errorString baseURL:nil];
}
/****************************************************************************/
#pragma mark - MFMailComposerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
    [self dismissModalViewControllerAnimated:YES];
}
/****************************************************************************/
#pragma mark - QLPreviewControllerDataSource
/****************************************************************************/
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}
/****************************************************************************/
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:self.pdfPath];
}
/****************************************************************************/
#pragma mark - Button Events
/****************************************************************************/
- (IBAction)previewPressed:(id)sender 
{
	QLPreviewController* preview = [[[QLPreviewController alloc] init] autorelease];
	preview.dataSource = self;
	[self presentModalViewController:preview animated:YES];
}
/****************************************************************************/
- (IBAction)emailPressed:(id)sender 
{
	// email the PDF File. 
	MFMailComposeViewController* mailComposer = [[[MFMailComposeViewController alloc] init] autorelease];
	mailComposer.mailComposeDelegate = self;
	[mailComposer addAttachmentData:[NSData dataWithContentsOfFile:self.pdfPath]
						   mimeType:@"application/pdf" fileName:@"site.pdf"];
	
	[self presentModalViewController:mailComposer animated:YES];
}
/****************************************************************************/
@end
