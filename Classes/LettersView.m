//
//  TilesView.m
//  Bubbles
//
//  Created by Jesse Grosjean on 9/17/08.
//  Copyright 2008 Hog Bay Software. All rights reserved.
//

#import "LettersView.h"
#import "Letter.h"
#import "LetterGroup.h"


@implementation LettersView

+ (UIColor *)foregroundColor {
	return [UIColor whiteColor];
}

+ (UIColor *)backgroundColor {
	return [UIColor blackColor];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)awakeFromNib {
	UILabel *name = [[[UILabel alloc] init] autorelease];
	name.text = NSLocalizedString(@"Letters", nil);
	name.font = [UIFont boldSystemFontOfSize:24];
	name.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
	name.backgroundColor = [UIColor clearColor];
	name.userInteractionEnabled = NO;
	[name sizeToFit];
	
	UILabel *instructions = [[[UILabel alloc] init] autorelease];
	instructions.text = NSLocalizedString(@"Tap to start & clear in order.", nil);
	instructions.textColor = [UIColor lightGrayColor];
	instructions.backgroundColor = [UIColor clearColor];
	instructions.userInteractionEnabled = NO;
	[instructions sizeToFit];
	
	UILabel *company = [[[UILabel alloc] init] autorelease];
	company.text = @"by Hog Bay Software";
	company.textColor = [UIColor lightGrayColor];
	company.backgroundColor = [UIColor clearColor];
	company.userInteractionEnabled = NO;
	[company sizeToFit];
	
	information = [[UIView alloc] init];
	information.alpha = 0.0;
	[information addSubview:name];
	[information addSubview:company];	
	[information addSubview:instructions];	
	
	CGRect nameFrame = name.frame;
	CGRect companyFrame = company.frame;
	CGRect instructionsFrame = instructions.frame;
	
	// layotu frames
	companyFrame.origin.y += nameFrame.size.height;
	company.frame = companyFrame;
	instructionsFrame.origin.y += nameFrame.size.height + companyFrame.size.height;
	instructions.frame = instructionsFrame;
	
	// group frames in infromation view
	CGRect informationFrame = information.frame;
	informationFrame = CGRectUnion(informationFrame, nameFrame);
	informationFrame = CGRectUnion(informationFrame, instructionsFrame);
	informationFrame = CGRectUnion(informationFrame, companyFrame);
	information.frame = informationFrame;
	
	// center frames horizontally
	nameFrame.origin.x += ((informationFrame.size.width - nameFrame.size.width) / 2);
	name.frame = nameFrame;
	instructionsFrame.origin.x += ((informationFrame.size.width - instructionsFrame.size.width) / 2);
	instructions.frame = instructionsFrame;
	companyFrame.origin.x += ((informationFrame.size.width - companyFrame.size.width) / 2);
	company.frame = companyFrame;
	
	[self addSubview:information];
	
	information.center = self.center;
	
	loading = YES;
	self.showInformation = YES;
	loading = NO;	
}

@synthesize score;
@synthesize group;

- (void)setGroup:(LetterGroup *)newGroup {
	[group autorelease];
	group = [newGroup retain];
	self.score = 0;
	sequenceNumber = 0;
	if (!group) {
		self.showInformation = YES;
	} else {
		self.showInformation = NO;
		[self doAnimation];
	}
}

@synthesize showInformation;

- (void)setShowInformation:(BOOL)newBool {
	if (showInformation != newBool) {
		showInformation = newBool;
		if (!loading) [UIView beginAnimations:@"instructions" context:NULL];
		if (showInformation) {
			information.alpha = 1.0;
		} else {
			information.alpha = 0.0;
		}
		if (!loading) [UIView commitAnimations];
	}
}

- (void)randomizeArray:(NSMutableArray *)array {
	NSUInteger i, n = [array count];
	for(i = 0; i < n; i++) {
		int destinationIndex = random() % (n - i) + i;
		[array exchangeObjectAtIndex:i withObjectAtIndex:destinationIndex];
	}
}

- (void)loadNewGame {
	sequenceNumber = 0;
	
	NSMutableArray *tiles = [[[NSMutableArray alloc] init] autorelease];
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	NSString *glyphSetString = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Capitals.glyphset"]];
	
	NSEnumerator *glyphEnumerator = [[glyphSetString componentsSeparatedByString:@"###\n"] objectEnumerator];
	NSString *eachGlyphString;
	
	while (eachGlyphString = [glyphEnumerator nextObject]) {
		if ([eachGlyphString length] > 0) {
			CGMutablePathRef glyphPath = CGPathCreateMutable();
			NSEnumerator *glyphComponentEnumerator = [[eachGlyphString componentsSeparatedByString:@"\n"] objectEnumerator];
			NSString *eachGlyphComponent;
			
			while (eachGlyphComponent = [glyphComponentEnumerator nextObject]) {
				if ([eachGlyphString length] > 0) {
					if ([eachGlyphComponent isEqualToString:@"1"]) {
						NSNumber *x1 = [numberFormatter numberFromString:[glyphComponentEnumerator nextObject]];
						NSNumber *y1 = [numberFormatter numberFromString:[glyphComponentEnumerator nextObject]];
						CGPathMoveToPoint(glyphPath, NULL, [x1 floatValue], [y1 floatValue]);
					} else if ([eachGlyphComponent isEqualToString:@"2"]) {
						NSNumber *x1 = [numberFormatter numberFromString:[glyphComponentEnumerator nextObject]];
						NSNumber *y1 = [numberFormatter numberFromString:[glyphComponentEnumerator nextObject]];
						CGPathAddLineToPoint(glyphPath, NULL, [x1 floatValue], [y1 floatValue]);
					} else if ([eachGlyphComponent isEqualToString:@"3"]) {
						NSNumber *x1 = [numberFormatter numberFromString:[glyphComponentEnumerator nextObject]];
						NSNumber *y1 = [numberFormatter numberFromString:[glyphComponentEnumerator nextObject]];
						NSNumber *x2 = [numberFormatter numberFromString:[glyphComponentEnumerator nextObject]];
						NSNumber *y2 = [numberFormatter numberFromString:[glyphComponentEnumerator nextObject]];
						NSNumber *x3 = [numberFormatter numberFromString:[glyphComponentEnumerator nextObject]];
						NSNumber *y3 = [numberFormatter numberFromString:[glyphComponentEnumerator nextObject]];
						CGPathAddCurveToPoint(glyphPath, NULL, [x1 floatValue], [y1 floatValue], [x2 floatValue], [y2 floatValue], [x3 floatValue], [y3 floatValue]);
					} else if ([eachGlyphComponent isEqualToString:@"4"]) {
						CGPathCloseSubpath(glyphPath);
					}
				}
			}
			[tiles addObject:[[[Letter alloc] initWithGlyphPath:glyphPath sequenceNumber:sequenceNumber++] autorelease]];
			
			CFRelease(glyphPath);
		}
	}
	
	[self randomizeArray:tiles];
	
	self.group = (id) [LetterGroup groupAndPositionTiles:tiles inRect:self.bounds];		
}

- (void)doAnimation {
	animationStart = [NSDate timeIntervalSinceReferenceDate];
	animationDuration = 0.3;
	[LettersView cancelPreviousPerformRequestsWithTarget:self selector:@selector(stepAnimations) object:nil];
	[self performSelector:@selector(stepAnimations) withObject:nil afterDelay:0];
}

- (void)stepAnimations {
	NSTimeInterval currentClock = [NSDate timeIntervalSinceReferenceDate];	
	CGFloat progress = ((currentClock - animationStart) / (CGFloat) animationDuration);
	
	progress = MIN(1, progress);
	progress = MAX(0, progress);
	
	[group stepAnimationWithProgress:progress];

	[self setNeedsDisplay];
	
	if (currentClock < (animationStart + animationDuration)) {
		[self performSelector:@selector(stepAnimations) withObject:nil afterDelay:1.0/30.0];
	} else {
		NSMutableArray *allTiles = [NSMutableArray array];
		[self.group collectEntireContentsWithSelf:allTiles];
		for (Letter *each in allTiles) {
			if (each.sequenceNumber == sequenceNumber) {
				each.weight += 0.25;
			}
		}
		[self.group animateToFrame:self.group.frame];
		[self doAnimation];
	}
}

- (void)drawRect:(CGRect)rect {
	[[LettersView backgroundColor] set];
	UIRectFill(rect);
	[[LettersView foregroundColor] set];
	[group drawRect:rect];
}

- (void)updateTouching:(UIEvent *)event {
	BOOL doAnimation = NO;
	
	for (UITouch *each in event.allTouches) {
		CGPoint touchLocation = [each locationInView:self];
		Letter *picked = [group pick:touchLocation];
		UITouchPhase phase = each.phase;
		
		if (phase != UITouchPhaseEnded && phase != UITouchPhaseCancelled) {
			if (picked.sequenceNumber == sequenceNumber) {
				if (phase == UITouchPhaseBegan) {
					NSTimeInterval currentSequencePickTime = [NSDate timeIntervalSinceReferenceDate];
					NSUInteger currentSequencePickScore = 0;
					if (lastSequencePickTime != 0) {
						currentSequencePickScore = 1.0 / ((currentSequencePickTime - lastSequencePickTime) / 5);
						if (currentSequencePickScore > 1) {
							currentSequencePickScore = (currentSequencePickScore + (lastSequencePickScore / 100)) * 10;
							self.score += currentSequencePickScore;
							/*
							UILabel *scoreLable = [[[UILabel alloc] init] autorelease];
							scoreLable.backgroundColor = nil;
							scoreLable.font = [UIFont systemFontOfSize:72];
							scoreLable.opaque = NO;
							scoreLable.textColor = [TilesView foregroundColor];
							scoreLable.text = [NSString stringWithFormat:@"+%i", (int) currentSequencePickScore];
							[scoreLable sizeToFit];
							scoreLable.center = CGPointMake(CGRectGetMidX(picked.frame), CGRectGetMidY(picked.frame));
							
							
							[self addSubview:scoreLable];
							[CATransaction begin];
							[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
							[CATransaction commit];*/
						}
					}
					lastSequencePickScore += currentSequencePickScore;
					lastSequencePickTime = currentSequencePickTime;
					[picked.group removeTile:picked];
					
					if ([group isEmpty]) {
						self.group = nil;
					} else {
						[group animateToFrame:group.frame];
						sequenceNumber++;
						doAnimation = YES;
					}
				}
			} else {
				if (picked) {
					// Bad pick... should make a bad sound.
					lastSequencePickScore = 0;
				}
			}
		}
	}
	if (doAnimation) {
		[self doAnimation];
	} else {
		[self setNeedsDisplay];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (self.showInformation) {
		[self loadNewGame];
		return;
	}
	[self updateTouching:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self updateTouching:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self updateTouching:event];
}

- (void)touchesCanceled {
}

- (void)dealloc {
	[group release];
	[super dealloc];
}

@end
