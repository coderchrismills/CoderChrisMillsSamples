//
//  FavoriteLocationView.h
//  MapFriends
//
//  Created by Richard Mills on 2/18/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import <UIKit/UIKit.h>
/****************************************************************************/
@interface FavoriteLocationView : UIView
{
    
}
/****************************************************************************/
@property (nonatomic, strong) IBOutlet UILabel *locationName;
@property (nonatomic, strong) IBOutlet UIImageView *locationScore;
/****************************************************************************/
- (void)setLocationWith:(NSString *)name
                  score:(NSNumber *)score;
/****************************************************************************/
@end
