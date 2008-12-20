//
//  iMovesAppDelegate.h
//  iMoves
//
//  Created by Brian Wilke on 11/18/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in gpl.txt.

#import <UIKit/UIKit.h>

@interface iMovesAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
    IBOutlet UINavigationController *navigationController;
}

- (void)createViews;

@property (nonatomic, retain) UIWindow *window;

@end

