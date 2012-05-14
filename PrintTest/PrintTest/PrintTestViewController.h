//
//  PrintTestViewController.h
//  PrintTest
//
//  Created by Chris Mills on 6/24/11.
//
/****************************************************************************/
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuickLook/QuickLook.h>
/****************************************************************************/
@interface PrintTestViewController : UIViewController <UIWebViewDelegate,
														MFMailComposeViewControllerDelegate, 
														QLPreviewControllerDataSource>
{
	UIWebView *printContentWebView;
	NSString *pdfPath;
}
/****************************************************************************/
@property (nonatomic, retain) IBOutlet UIWebView *printContentWebView;
@property (nonatomic, retain) NSString *pdfPath;
/****************************************************************************/
- (void)drawPageNumber:(NSInteger)pageNum;
- (IBAction)previewPressed:(id)sender;
- (IBAction)emailPressed:(id)sender;
	
@end
