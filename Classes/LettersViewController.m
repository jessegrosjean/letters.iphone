//
//  LettersViewController.m
//  Letters
//
//  Created by Jesse Grosjean on 4/24/09.
//  Copyright Hog Bay Software 2009. All rights reserved.
//

#import "LettersViewController.h"

@implementation LettersViewController

- (void)viewDidLoad {
	srandomdev();
	[super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}

@end
