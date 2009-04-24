//
//  Delegate.m
//  SetBuilder
//
//  Created by Jesse Grosjean on 10/10/08.
//  Copyright 2008 Hog Bay Software. All rights reserved.
//

#import "Delegate.h"


@implementation Delegate

- (IBAction)saveSet:(id)sender {
	NSCharacterSet *whitespaceAndNewlineCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSMutableString *setString = [NSMutableString string];
	NSLayoutManager *layoutManager = [textView layoutManager];
	NSTextStorage *storage = [textView textStorage];
	
	NSUInteger charIndex = 0;
	NSUInteger length = [storage length];
	while (charIndex < length) {
		if ([whitespaceAndNewlineCharacterSet characterIsMember:[[storage string] characterAtIndex:charIndex]]) {
			charIndex++; // skip whitespace and newline
		} else {
			[setString appendFormat:@"###\n"];
			
			NSUInteger glyphIndex = [layoutManager glyphIndexForCharacterAtIndex:charIndex];
			NSFont *font = [storage attribute:NSFontAttributeName atIndex:charIndex effectiveRange:NULL];
			NSGlyph glyph = [layoutManager glyphAtIndex:glyphIndex];
			NSBezierPath *glyphPath = [NSBezierPath bezierPath];
			
			[glyphPath moveToPoint:NSMakePoint(0, 0)];
			[glyphPath appendBezierPathWithGlyph:glyph inFont:font];
			
			NSAffineTransform *transform = [NSAffineTransform transform];
			[transform scaleXBy:1 yBy:-1];
			[glyphPath transformUsingAffineTransform:transform];

			NSRect glyphBounds = [glyphPath bounds];
			transform = [NSAffineTransform transform];
			[transform translateXBy:-glyphBounds.origin.x yBy:-glyphBounds.origin.y];
			[glyphPath transformUsingAffineTransform:transform];

			NSUInteger elementCount = [glyphPath elementCount];
			NSUInteger i = 0;
			NSPoint points[3];
			
			while (i < elementCount) {
				NSBezierPathElement element = [glyphPath elementAtIndex:i associatedPoints:points];
				switch (element) {
					case NSMoveToBezierPathElement:
						[setString appendString:@"1\n"];
						[setString appendFormat:@"%f\n", points[0].x]; 
						[setString appendFormat:@"%f\n", points[0].y]; 
						break;
					case NSLineToBezierPathElement:
						[setString appendString:@"2\n"];
						[setString appendFormat:@"%f\n", points[0].x]; 
						[setString appendFormat:@"%f\n", points[0].y]; 
						break;
					case NSCurveToBezierPathElement:
						[setString appendString:@"3\n"];
						[setString appendFormat:@"%f\n", points[0].x]; 
						[setString appendFormat:@"%f\n", points[0].y]; 
						[setString appendFormat:@"%f\n", points[1].x]; 
						[setString appendFormat:@"%f\n", points[1].y]; 
						[setString appendFormat:@"%f\n", points[2].x]; 
						[setString appendFormat:@"%f\n", points[2].y]; 
						break;
					case NSClosePathBezierPathElement:
						[setString appendString:@"4\n"];
						break;
				}
				i++;
			}
			charIndex++;
		}
	}	
	
	NSSavePanel *savePanel = [NSSavePanel savePanel];

	[savePanel setRequiredFileType:@"glyphset"];
	
	if ([savePanel runModal] == NSFileHandlingPanelOKButton) {
		[setString writeToFile:[savePanel filename] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	}
}

@end
