//
//  LettersAppDelegate.h
//  Letters
//
//  Created by Jesse Grosjean on 4/24/09.
//  Copyright Hog Bay Software 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LettersViewController;

@interface LettersAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LettersViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LettersViewController *viewController;

@end

