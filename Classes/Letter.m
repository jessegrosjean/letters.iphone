//
//  PTile.m
//  Pace
//
//  Created by Jesse Grosjean on 9/17/08.
//  Copyright 2008 Hog Bay Software. All rights reserved.
//

#import "Letter.h"
#import "LetterGroup.h"


@implementation Letter

- (id)initWithGlyphPath:(CGPathRef)aGlyphPath sequenceNumber:(NSUInteger)aSequenceNumber {
	if (self = [super init]) {
		sequenceNumber = aSequenceNumber;
		glyphPath = CGPathRetain(aGlyphPath);
		glyphPathBoundingBox = CGPathGetBoundingBox(glyphPath);
		[self calculateWeightFromSequenceNumber:0];
	}
	return self;
}

@synthesize group;

- (void)setGroup:(LetterGroup *)newGroup {
	group = newGroup;
}

@synthesize weight;

- (void)calculateWeightFromSequenceNumber:(NSUInteger)aSequenceNumber {
	CGFloat diff = sequenceNumber - aSequenceNumber;
	CGFloat maxLettersCount = 0;

	if (NSClassFromString(@"UISplitViewController")) {
		maxLettersCount = 27;
		//if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	} else {
		maxLettersCount = 7;
	}
		
	if (diff > maxLettersCount) {
		weight = 0.005;
	} else {
		//0, 1, 2, 3;
		weight = 1.0 - (diff / maxLettersCount);
		//weight = sqrtf(weight);
	}
}

- (void)randomizeWeight {
	weight = (random() % 100) / (CGFloat) 100;
	if (weight < 0.3) weight = 0.3;
}

@synthesize sequenceNumber;
@synthesize frame;

- (void)setStartFrame:(CGRect)aFrame {
	self.frame = aFrame;
	if (glyphPath) {
		BOOL glyphAspectRatio = glyphPathBoundingBox.size.width / glyphPathBoundingBox.size.height > 1.0;
		BOOL frameAspectRatio = frame.size.width / frame.size.height > 1.0;
		
		if (glyphAspectRatio != frameAspectRatio) {
			flipper = YES;
		}
	}
}

- (void)drawRect:(CGRect)aRect currentSequenceNumber:(NSUInteger)currentSequenceNumber {
	if (weight < 0.01) {
		return;
	}
			
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect scaleToFitRect = frame;

	CGContextSaveGState(context);
	CGContextTranslateCTM(context, frame.origin.x, frame.origin.y);

	if (weight >= 1.0) {
		//CGContextSetShouldAntialias(context, YES);
		//CGContextSetFlatness(context, 1);
	} else {
		[[UIColor colorWithWhite:weight alpha:1.0] set];
		
		/*if (weight > 0.8) {
			CGContextSetFlatness(context, 5);
			//CGContextSetShouldAntialias(context, YES);
		} else {
			CGContextSetFlatness(context, 1000);
			//CGContextSetShouldAntialias(context, NO);
		}*/
	}
	
	if (flipper) {
		CGFloat scaleX = scaleToFitRect.size.width / glyphPathBoundingBox.size.height;
		CGFloat scaleY = scaleToFitRect.size.height / glyphPathBoundingBox.size.width;
		CGContextScaleCTM(context, scaleX, scaleY);
		CGContextRotateCTM(context, 3.14/2);		
		CGContextTranslateCTM(context, 0, -glyphPathBoundingBox.size.height);
	} else {
		CGFloat scaleX = scaleToFitRect.size.width / glyphPathBoundingBox.size.width;
		CGFloat scaleY = scaleToFitRect.size.height / glyphPathBoundingBox.size.height;
		CGContextScaleCTM(context, scaleX, scaleY);
	}

	CGContextAddPath(context, glyphPath);
	CGContextFillPath(context);
	
	CGContextRestoreGState(context);
}

- (void)animateToFrame:(CGRect)aRect {
	animationStartFrame = frame;
	animationEndFrame = aRect;
}

- (void)stepAnimationWithProgress:(CGFloat)progress {
	if (!CGRectEqualToRect(animationStartFrame, CGRectZero) && !CGRectEqualToRect(animationEndFrame, CGRectZero)) {
		self.frame = CGRectMake((animationStartFrame.origin.x * (1 - progress)) + (animationEndFrame.origin.x * progress),
								(animationStartFrame.origin.y * (1 - progress)) + (animationEndFrame.origin.y * progress),
								(animationStartFrame.size.width * (1 - progress)) + (animationEndFrame.size.width * progress),
								(animationStartFrame.size.height * (1 - progress)) + (animationEndFrame.size.height * progress));
	}
	
	if (progress >= 1) {
		animationStartFrame = CGRectZero;
		animationEndFrame = CGRectZero;
	}
}

- (Letter *)pick:(CGPoint)location {
	if (CGRectContainsPoint(frame, location)) {
		return self;
	}
	return nil;
}

- (void)collectEntireContentsWithSelf:(NSMutableArray *)results {
	[results addObject:self];
}

- (void)dealloc {
	group = nil;
	CGPathRelease(glyphPath);
	[super dealloc];
}

@end
