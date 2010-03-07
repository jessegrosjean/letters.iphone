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
#import "LettersViewController.h"


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

- (void)initDisplay {	
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

- (void)layoutSubviews {
	[super layoutSubviews];

	CGPoint center = self.center;
	center = [self convertPoint:center fromView:self.superview];
	information.center = center;
	[group animateToFrame:self.bounds];
	[group stepAnimationWithProgress:1.0];
}

@synthesize group;

- (void)setGroup:(LetterGroup *)newGroup {
	[group autorelease];
	group = [newGroup retain];
	sequenceNumber = 0;
	if (!group) {
		[self stopAnimation];
		self.showInformation = YES;
	} else {
		self.showInformation = NO;
		[self startAnimation];
	}
	[self setNeedsDisplay];
	[self setNeedsLayout];
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
	NSMutableArray *tiles = [lettersViewController tiles];
	
	if (tiles) {
		sequenceNumber = 0;
		[self randomizeArray:[lettersViewController tiles]];
		self.group = (id) [LetterGroup groupAndPositionTiles:[lettersViewController tiles] inRect:self.bounds];
		[group calculateWeightFromSequenceNumber:sequenceNumber];
		[self setNeedsLayout];
	} else {
		[self performSelector:@selector(loadNewGame) withObject:nil afterDelay:0.5];
	}
}

- (void)startAnimation {
	if (!animationTimer) {
		[animationTimer invalidate];
		[animationTimer release];
		animationTimer = [[NSTimer scheduledTimerWithTimeInterval:1.0/24.0 target:self selector:@selector(stepAnimations) userInfo:nil repeats:YES] retain];
		animationStart = [NSDate timeIntervalSinceReferenceDate];
		animationDuration = 0.3;
	}
}

- (void)stopAnimation {
	[animationTimer invalidate];
	[animationTimer release];
	animationTimer = nil;
}

- (void)stepAnimations {
	NSTimeInterval currentClock = [NSDate timeIntervalSinceReferenceDate];	
	CGFloat progress = ((currentClock - animationStart) / (CGFloat) animationDuration);
	
	progress = MIN(1, progress);
	progress = MAX(0, progress);
	
	[group stepAnimationWithProgress:progress];
	
	[self setNeedsDisplay];
	
	// If completed current animation schedule a long term grow animation
	// for the current tile.
	if (currentClock > (animationStart + animationDuration)) {
		NSMutableArray *allTiles = [NSMutableArray array];
		[self.group collectEntireContentsWithSelf:allTiles];
		for (Letter *each in allTiles) {
			if (each.sequenceNumber == sequenceNumber) {
				each.weight += (0.05 * 30 * 1);
			}
		}
		[self.group animateToFrame:self.group.frame];
		animationStart = [NSDate timeIntervalSinceReferenceDate];
		animationDuration = 1.0;
	}
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//CGContextSetAllowsAntialiasing(context, NO);
	//CGContextSetShouldAntialias(context, NO);
	CGContextSetShouldSmoothFonts(context, NO);
	//CGContextSetInterpolationQuality(context, kCGInterpolationNone);
	CGContextSetFlatness(context, 1);
	
	[[LettersView backgroundColor] set];
	UIRectFill(rect);
	[[LettersView foregroundColor] set];
	[group drawRect:rect currentSequenceNumber:sequenceNumber];
}

- (void)updateTouching:(UIEvent *)event {
	for (UITouch *each in event.allTouches) {
		CGPoint touchLocation = [each locationInView:self];
		Letter *picked = [group pick:touchLocation];
		UITouchPhase phase = each.phase;
		
		if (phase != UITouchPhaseEnded && phase != UITouchPhaseCancelled) {
			if (picked.sequenceNumber == sequenceNumber) {
				if (phase == UITouchPhaseBegan) {
					[picked.group removeTile:picked];
					
					if ([group isEmpty]) {
						self.group = nil;
					} else {
						sequenceNumber++;
						[group calculateWeightFromSequenceNumber:sequenceNumber];
						[group animateToFrame:group.frame];
						animationStart = [NSDate timeIntervalSinceReferenceDate];
						animationDuration = 0.3;
					}
				}
			}
		}
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

- (void)dealloc {
	[self stopAnimation];
	[group release];
	[super dealloc];
}

@end
