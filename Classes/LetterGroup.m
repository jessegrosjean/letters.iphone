//
//  PTileGroup.m
//  Pace
//
//  Created by Jesse Grosjean on 9/18/08.
//  Copyright 2008 Hog Bay Software. All rights reserved.
//

#import "LetterGroup.h"


@implementation LetterGroup

+ (Letter *)groupAndPositionTiles:(NSArray *)tiles inRect:(CGRect)aRect {
	NSInteger count = [tiles count];
	
	if (count == 0) return nil;
	if (count == 1) {
		Letter *tile = [tiles lastObject];
		[tile setStartFrame:aRect];
		return tile;
	} else {
		NSInteger mid = count / 2;
		NSArray *headTiles = [tiles subarrayWithRange:NSMakeRange(0, mid)];
		NSArray *tailTiles = [tiles subarrayWithRange:NSMakeRange(mid, count - mid)];
		CGFloat headWeight = [[headTiles valueForKeyPath:@"@sum.weight"] floatValue];
		CGFloat tailWeight = [[tailTiles valueForKeyPath:@"@sum.weight"] floatValue];
		CGFloat amount;
		CGRectEdge edge;
		
		if (aRect.size.width > aRect.size.height) {
			amount = aRect.size.width * (headWeight / (headWeight + tailWeight));
			edge = CGRectMinXEdge;
		} else {
			amount = aRect.size.height * (headWeight / (headWeight + tailWeight));
			edge = CGRectMinYEdge;
		}
		
		CGRect headRect;
		CGRect tailRect;
		
		CGRectDivide(aRect, &headRect, &tailRect, amount, edge);
		
		Letter *group1 = [self groupAndPositionTiles:headTiles inRect:headRect];
		Letter *group2 = [self groupAndPositionTiles:tailTiles inRect:tailRect];
		NSMutableArray *tiles = [[[NSMutableArray alloc] init] autorelease];
		
		if (group1) [tiles addObject:group1];
		if (group2) [tiles addObject:group2];
		
		if ([tiles count] > 0) {
			return [[[LetterGroup alloc] initWithTiles:tiles edge:edge frame:aRect] autorelease];
		} else {
			return nil;
		}
	}
	
	return nil;
}

- (id)initWithTiles:(NSMutableArray *)anArray edge:(CGRectEdge)anEdge frame:(CGRect)aFame {
	self = [super init];
	sequenceNumber = -1;
	tiles = [anArray retain];
	[tiles setValue:self forKey:@"group"];
	frame = aFame;
	edge = anEdge;
	return self;
}

- (CGFloat)weight {
	return [[tiles valueForKeyPath:@"@sum.weight"] floatValue];
}

//- (void)randomizeWeight {
//	[tiles makeObjectsPerformSelector:@selector(randomizeWeight)];
//}

- (void)calculateWeightFromSequenceNumber:(NSUInteger)aSequenceNumber {
	for (Letter *each in tiles) {
		[each calculateWeightFromSequenceNumber:aSequenceNumber];
	}
}

- (void)drawRect:(CGRect)aRect currentSequenceNumber:(NSUInteger)currentSequenceNumber {
	for (Letter *each in tiles) {
		if (CGRectIntersectsRect(aRect, each.frame)) {
			[each drawRect:aRect currentSequenceNumber:currentSequenceNumber];
		}
	}
}

- (BOOL)isEmpty {
	return [tiles count] == 0;
}

- (void)removeTile:(Letter *)aChild {
	[tiles removeObject:aChild];
	if ([tiles count] == 0) {
		[self.group removeTile:self];
	}
}

- (Letter *)pick:(CGPoint)location {
	if (CGRectContainsPoint(frame, location)) {
		for (Letter *each in tiles) {
			Letter *picked = [each pick:location];
			if (picked) {
				return picked;
			}
		}
	}
	return nil;	
}

- (void)stepAnimationWithProgress:(CGFloat)progress {
	[super stepAnimationWithProgress:progress];
	
	for (Letter *each in tiles) {
		[each stepAnimationWithProgress:progress];
	}
}

- (void)animateToFrame:(CGRect)newFrame {
	[super animateToFrame:newFrame];
		
	if ([tiles count] == 2) {
		CGFloat headWeight = [[tiles objectAtIndex:0] weight];
		CGFloat tailWeight = [[tiles objectAtIndex:1] weight];
		CGFloat amount;
		
		if (edge == CGRectMinXEdge) {
			amount = newFrame.size.width * (headWeight / (headWeight + tailWeight));
		} else if (edge == CGRectMinYEdge) {
			amount = newFrame.size.height * (headWeight / (headWeight + tailWeight));
		} else {
			NSLog(@"error");
		}
		
		CGRect headRect;
		CGRect tailRect;
		
		CGRectDivide(newFrame, &headRect, &tailRect, amount, edge);
		
		[[tiles objectAtIndex:0] animateToFrame:headRect];
		[[tiles objectAtIndex:1] animateToFrame:tailRect];
		
	} else if ([tiles count] == 1) {
		[[tiles lastObject] animateToFrame:newFrame];
	} else {
		NSLog(@"error");
	}
}

- (void)collectEntireContentsWithSelf:(NSMutableArray *)results {
	[super collectEntireContentsWithSelf:results];

	for (Letter *each in tiles) {
		[each collectEntireContentsWithSelf:results];
	}
}

- (void)dealloc {
	[tiles release];
	[super dealloc];
}

@end
