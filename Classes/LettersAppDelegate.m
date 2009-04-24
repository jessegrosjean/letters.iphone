//
//  LettersAppDelegate.m
//  Letters
//
//  Created by Jesse Grosjean on 4/24/09.
//  Copyright Hog Bay Software 2009. All rights reserved.
//

#import "LettersAppDelegate.h"
#import "LettersViewController.h"

@implementation LettersAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[application setStatusBarHidden:YES animated:NO];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
