//
//  LettersViewController.h
//  Letters
//
//  Created by Jesse Grosjean on 4/24/09.
//  Copyright Hog Bay Software 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LettersViewController : UIViewController {
	IBOutlet UIActivityIndicatorView *loadingProgress;
	
	NSMutableArray *tiles;
}

@property (retain) NSMutableArray *tiles;

@end

