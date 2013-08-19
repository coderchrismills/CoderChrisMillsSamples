//
//  WebPopOverViewController.h
//  PrintTest2
//
//  Created by Richard Mills on 8/18/13.
//  Copyright (c) 2013 Happy Maau Studios, LLC. All rights reserved.
//
/****************************************************************************/
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BNHtmlPdfKit.h"
/****************************************************************************/
@interface WebPopOverViewController : UIViewController <BNHtmlPdfKitDelegate,
                                                        MFMailComposeViewControllerDelegate,
                                                        UIWebViewDelegate>
{
    
}
/****************************************************************************/
@property (nonatomic, strong) NSString *pdfFilePath;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *composeButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *actionButton;
/****************************************************************************/
- (IBAction)donePressed:(id)sender;
- (IBAction)composePressed:(id)sender;
- (IBAction)actionPressed:(id)sender;
/****************************************************************************/
@end
