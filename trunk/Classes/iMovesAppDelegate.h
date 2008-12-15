//
//  iMovesAppDelegate.h
//  iMoves
//
//  Created by Brian Wilke on 11/18/08.
//  Copyright Fluke Networks 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iMovesAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
    IBOutlet UINavigationController *navigationController;
}

- (void)createViews;

@property (nonatomic, retain) UIWindow *window;

@end

