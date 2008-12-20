//
//  GestureVisualizer.h
//  iMoves
//
//  Created by Brian Wilke on 12/7/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in the "GPL License" folder as gpl.txt.

#import <UIKit/UIKit.h>

#import "Gestures.h"
#import "NavigationView.h"

// Constant for the number of acceleration samples kept in history.
#define kHistorySize 75

// Constant for maximum acceleration
#define kMaxAcceleration 3.0

@interface GestureVisualizer : UIView <GestureTrackerDelegate>
{
    Gesture* gesture;         // gesture to visualize
    GestureTracker* tracker;  // tracker that tracks the visualized gesture
    
    UILabel* nameLabel;       // name of gesture
    UILabel* numFramesLabel;  // number of frames in gesture
    UILabel* frameLabel;      // currently matched frame
    UILabel* occurredLabel;   // did the gesture occur?
    UILabel* loLabel;         // last occurrence of gesture
    
    UIAccelerationValue history[kHistorySize][3];  // acceleration history to display
    NSUInteger nextIndex;     // history index
    NSUInteger numOccurrences; // number of occurences of gesture
}

- (void)drawHistory:(unsigned)axis fromIndex:(unsigned)index inContext:(CGContextRef)context withBounds:(CGRect)bounds;
- (void)createGestureView;

- (void)setGesture:(Gesture *)g withTracker:(GestureTracker *)t;

- (void)enableDelegation;
- (void)disableDelegation;

- (void)gestureOccurred:(Gesture *)gesture atTime:(NSTimeInterval)time;
- (void)gesturePartiallyOccurred:(Gesture *)gesture withCompletedFrames:(NSUInteger)frames atTime:(NSTimeInterval)time;
- (void)updatedAccelerationValues;

@end

@interface GestureVisualizerController : UIViewController <NavigationViewDelegate>
{
    GestureVisualizer* gv;     // the visualization view
}

- (void)setGesture:(Gesture *)g withTracker:(GestureTracker *)t;

- (void)selectedRowWithParameters:(NSArray *)params;

@end

