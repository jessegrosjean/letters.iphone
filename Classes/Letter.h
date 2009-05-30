//
//  PTile.h
//  Pace
//
//  Created by Jesse Grosjean on 9/17/08.
//  Copyright 2008 Hog Bay Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class LetterGroup;

@interface Letter : NSObject {
	LetterGroup *group;
	NSUInteger sequenceNumber;
	CGPathRef glyphPath;
	CGRect glyphPathBoundingBox;
	CGRect frame;
	CGFloat weight;
	CGRect animationStartFrame;
	CGRect animationEndFrame;
	BOOL flipper;
}

- (id)initWithGlyphPath:(CGPathRef)aGlyphPath sequenceNumber:(NSUInteger)aSequenceNumber;

@property (readonly) LetterGroup *group;
@property (assign) CGRect frame;
@property (assign) CGFloat weight;
@property (readonly) NSUInteger sequenceNumber;

- (void)calculateWeightFromSequenceNumber:(NSUInteger)aSequenceNumber;

- (void)randomizeWeight;
- (void)setStartFrame:(CGRect)aFrame;
- (void)drawRect:(CGRect)aRect currentSequenceNumber:(NSUInteger)currentSequenceNumber;
- (void)animateToFrame:(CGRect)aRect;
- (void)stepAnimationWithProgress:(CGFloat)progress;
- (Letter *)pick:(CGPoint)location;
- (void)collectEntireContentsWithSelf:(NSMutableArray *)results;

@end
