//
//  NavigationGestures.h
//  iMoves
//
//  Created by Brian Wilke on 11/24/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in gpl.txt.

#import <UIKit/UIKit.h>

#import "Gestures.h"

@protocol NavigationGestureDelegate

- (void)scrollUp;
- (void)scrollDown;
- (void)goForward;
- (void)goBackward;

@end

@interface NavigationGestures : NSObject <GestureTrackerDelegate>
{
    Gesture* scroll_up;        // scroll up in table navigation
    Gesture* scroll_down;      // scroll down in table navigation
    Gesture* go_forward;       // go forward in table navigation
    Gesture* go_backward;      // go backward in table navigation
    
    GestureTracker* tracker;   // the gesture tracker
    HighPassFilter *hpf;       // the high pass filter
    
    id delegate;               // delegate for passing off gestures
}

@property (nonatomic, retain) GestureTracker* tracker;
@property (nonatomic, retain) Gesture* scroll_up;
@property (nonatomic, retain) Gesture* scroll_down;
@property (nonatomic, retain) Gesture* go_forward;
@property (nonatomic, retain) Gesture* go_backward;

- (id)init;
- (id)initWithUpdateInterval:(double)updateInterval andHighPassFilterFactor:(double)factor;
- (id)initWithUpdateFrequency:(double)updateFrequency andHighPassFilterFactor:(double)factor;

- (void)setDelegate:(id <NavigationGestureDelegate>)new_delegate;
- (void)unsetDelegate;

+ (Gesture *)createScrollUpGesture;
+ (Gesture *)createScrollDownGesture;
+ (Gesture *)createGoForwardGesture;
+ (Gesture *)createGoBackwardGesture;

@end
