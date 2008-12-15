//
//  iMovesViewController.h
//  iMoves
//
//  Created by Brian Wilke on 11/18/08.
//  Copyright 2008 Fluke Networks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NavigationView.h"
#import "MovesView.h"


@interface iMovesViewController : UINavigationController
{
    IBOutlet NavigationView* navView;
}

@property (nonatomic, retain) NavigationView* navView;

@end
