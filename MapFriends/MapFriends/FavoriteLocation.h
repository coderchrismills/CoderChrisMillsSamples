//
//  FavoriteLocation.h
//  MapFriends
//
//  Created by Richard Mills on 2/10/13.
//  Copyright (c) 2013 Happy Maau. All rights reserved.
//
/****************************************************************************/
#import <Foundation/Foundation.h>
/****************************************************************************/
@interface FavoriteLocation : NSObject
{
    
}
/****************************************************************************/
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSNumber *locationScore;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
/****************************************************************************/
- (id)initWithName:(NSString *)name
             score:(NSNumber *)score
          latitude:(CGFloat)lat
         longitude:(CGFloat)lon
         thumbnail:(NSString *)path;
/****************************************************************************/
@end
