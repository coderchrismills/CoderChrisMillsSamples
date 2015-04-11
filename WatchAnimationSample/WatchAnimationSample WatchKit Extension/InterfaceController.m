//
//  InterfaceController.m
//  WatchAnimationSample WatchKit Extension
//
//  Created by Chris Mills on 4/10/15.
//  Copyright (c) 2015 Chris Mills. All rights reserved.
//

@import QuartzCore;

#import "InterfaceController.h"

static NSString *const kAnimationName = @"Graph";

@interface InterfaceController()
{
	CGFloat initialY;
	NSInteger numberOfFrames;
	NSMutableArray *points;
}
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
	
	initialY = 90.0;
	numberOfFrames = 30;
	
	points = [[NSMutableArray alloc] init];
	[self makeNewPointSet];
	
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)animate {
	[self makeNewPointSet];
	if([self makeImageSet]) {
		[self.imageView setImageNamed:kAnimationName];
		[self.imageView startAnimatingWithImagesInRange:NSMakeRange(0, numberOfFrames) duration:1.0 repeatCount:1];
	}
}

- (void)makeNewPointSet {
	
	// Our initial line
	// o--o--o--o--o
	[points removeAllObjects];
	
	NSInteger numberOfPoints = 5;
	
	WKInterfaceDevice *device = [WKInterfaceDevice currentDevice];
	
	CGFloat width = [device screenBounds].size.width;
	CGFloat spacing = width / (numberOfPoints-1);
	
	for(NSInteger i = 0; i < numberOfPoints; i++) {
		CGFloat randomY = arc4random_uniform((int)initialY);
		[points addObject:[NSValue valueWithCGPoint:CGPointMake(i*spacing, randomY)]];
	}
}

- (BOOL)makeImageSet {
	WKInterfaceDevice *device = [WKInterfaceDevice currentDevice];
	[device removeAllCachedImages];
	CGFloat width = [device screenBounds].size.width;
	
	CGSize imageSize = CGSizeMake(width , initialY+10);
	
	NSMutableArray *images = [NSMutableArray array];
	
	for(NSInteger i = 0; i < numberOfFrames; i++) {
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, [device screenScale]);
		
		CGFloat time = i / ((CGFloat)numberOfFrames);
		UIBezierPath *path = [self drawPathForTime:time];
		[[UIColor redColor] setStroke];
		[[UIColor clearColor] setFill];
		
		[path fill];
		[path stroke];
		
		UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
		
		[images addObject:result];
	}
	
	UIImage *animated = [UIImage animatedImageWithImages:images duration:1.0f]; // 1 second.
	BOOL didCache = [device addCachedImage:animated name:kAnimationName];
	if(!didCache) {
		NSLog(@"Animation was not cached!");
		NSLog(@"%@", [device cachedImages]);
	}
	return didCache;
}

- (UIBezierPath *)drawPathForTime:(CGFloat)time {
	// time is assumed to be between [0,1].
	
	// Animate via linear interpolation. look at this line.
	// o
	//  \        o
	//   o--o   /
	//       \ /
	//        o
	
	UIBezierPath *path = [[UIBezierPath alloc] init];
	CGPoint point = [[points objectAtIndex:0] CGPointValue];
	[path moveToPoint:point];
	for(NSInteger i = 1; i < [points count]; i++) {
		point = [[points objectAtIndex:i] CGPointValue];
		point.y *= time;
		[path addLineToPoint:point];
	}
	
	return path;
}

@end



