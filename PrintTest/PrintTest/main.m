//
//  main.m
//  PrintTest
//
//  Created by Chris Mills on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PrintTestAppDelegate.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([PrintTestAppDelegate class]));
    [pool release];
	return retVal;
}
