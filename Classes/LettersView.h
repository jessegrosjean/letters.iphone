//
//  TilesView.h
//  Bubbles
//
//  Created by Jesse Grosjean on 9/17/08.
//  Copyright 2008 Hog Bay Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Letter;
@class LetterGroup;
@class LettersViewController;

@interface LettersView : UIView {
	IBOutlet LettersViewController *lettersViewController;
	
	UIView *information;
	BOOL showInformation;
	BOOL loading;
	LetterGroup *group;
	NSTimer *animationTimer;
	NSTimeInterval animationStart;
	NSTimeInterval animationDuration;
	NSUInteger sequenceNumber;
}

+ (UIColor *)foregroundColor;
+ (UIColor *)backgroundColor;

- (void)initDisplay;

@property (retain) LetterGroup *group;
@property (assign) BOOL showInformation;

- (void)startAnimation;
- (void)stopAnimation;

@end
