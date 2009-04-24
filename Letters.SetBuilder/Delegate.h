//
//  Delegate.h
//  SetBuilder
//
//  Created by Jesse Grosjean on 10/10/08.
//  Copyright 2008 Hog Bay Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Delegate : NSObject {
	IBOutlet NSTextView *textView;
}

- (IBAction)saveSet:(id)sender;

@end
