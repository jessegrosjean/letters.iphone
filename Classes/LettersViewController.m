//
//  LettersViewController.m
//  Letters
//
//  Created by Jesse Grosjean on 4/24/09.
//  Copyright Hog Bay Software 2009. All rights reserved.
//

#import "LettersViewController.h"
#import "LettersView.h"
#import "Letter.h"


@implementation LettersViewController

- (void)viewDidLoad {
	srandomdev();
	[super viewDidLoad];

	[(LettersView *)self.view initDisplay];

	CGPoint center = self.view.center;
	center.y = center.y / 2;
	loadingProgress.center = center;
	[loadingProgress startAnimating];
	[self performSelectorInBackground:@selector(loadTiles) withObject:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@synthesize tiles;

- (void)setTiles:(NSMutableArray *)newTiles {
	[tiles release];
	tiles = [newTiles retain];
	[loadingProgress stopAnimating];
}

- (void)loadTiles {
	NSUInteger sequenceNumber = 0;
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableArray *loadedTiles = [[NSMutableArray alloc] init];	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	NSString *glyphSetString = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Capitals.glyphset"] encoding:NSUTF8StringEncoding error:NULL];
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
			[loadedTiles addObject:[[[Letter alloc] initWithGlyphPath:glyphPath sequenceNumber:sequenceNumber++] autorelease]];
			
			CFRelease(glyphPath);
		}
	}
	
	[self performSelectorOnMainThread:@selector(setTiles:) withObject:loadedTiles waitUntilDone:NO];
	
	[pool release];
}

- (void)dealloc {
    [super dealloc];
}

@end
