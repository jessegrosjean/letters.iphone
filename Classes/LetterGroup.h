//
//  PTileGroup.h
//  Pace
//
//  Created by Jesse Grosjean on 9/18/08.
//  Copyright 2008 Hog Bay Software. All rights reserved.
//

#import "Letter.h"


@interface LetterGroup : Letter {
	NSMutableArray *tiles;
	CGRectEdge edge;
}

+ (Letter *)groupAndPositionTiles:(NSArray *)tiles inRect:(CGRect)aRect;

- (id)initWithTiles:(NSMutableArray *)anArray edge:(CGRectEdge)anEdge frame:(CGRect)aFame;

- (BOOL)isEmpty;
- (void)removeTile:(Letter *)aTile;

@end
