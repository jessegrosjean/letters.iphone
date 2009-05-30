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

@interface LettersView : UIView {
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

@property (retain) LetterGroup *group;
@property (assign) BOOL showInformation;

- (void)startAnimation;
- (void)stopAnimation;

@end
