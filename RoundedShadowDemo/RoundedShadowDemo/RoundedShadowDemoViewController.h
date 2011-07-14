//
//  RoundedShadowDemoViewController.h
//  Created by Chris Mills on 7/9/11.
//
/****************************************************************************/
#import <UIKit/UIKit.h>
/****************************************************************************/
@interface RoundedShadowDemoViewController : UIViewController
{	
	IBOutlet UIView *roundedView;
	
	float fCurrentCornerRadius;
	CGSize shadowOffsetSize;
}
/****************************************************************************/
-(IBAction)xShadowDidChange:(id)sender;
-(IBAction)yShadowDidChange:(id)sender;
-(IBAction)radiusDidChange:(id)sender;
/****************************************************************************/
@end
