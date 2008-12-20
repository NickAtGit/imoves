//
//  Gestures.h
//  iMoves
//
//  Defines 3 interfaces: the Frames data structure, the Gestures class and the GestureTracker class
//      The Frames data structure defines a single iPhone movement.  It specifies the starting position
//          of the phone, the intended ending position of the phone, and the associated
//          tolerances on moving from the starting to ending position.  The tolerances
//          include how fast the phone should be moved from start to end, whether the
//          positions are absolute or relative, the allowable error in the movement, etc.
//      The Gestures class provides the ability to define a gesture.
//          Gestures are a series of frames.
//      The GestureTracker class provides the ability to track whether a gesture
//          has occurred.  A gesture completely occurs if every frame has been visited in order
//          within each frame's specified tolerances.  Gestures can also occur partially
//          when a subset of the frames have been visited.
//
//  Created by Brian Wilke on 11/18/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in gpl.txt.

#import <UIKit/UIKit.h>

#import "Tolerances.h"
#import "Filter.h"


@interface Frame : NSObject 
{
@public
    
    // specified starting and ending positions
    UIAccelerationValue startPos[3];
    UIAccelerationValue endPos[3];
    NSTimeInterval start_end_time_delta;
    
    // tolerance
    SpatialTolerance* spatial_tolerance;
    TemporalTolerance* temporal_tolerance;
    
    BOOL use_last_frame_end_as_start; // use the last frame's ending position as the starting position
    BOOL end_pos_relative_to_start;   // ending position is specified relative to the starting position
}

- (id)init;
- (void)dealloc;

- (void)allowSpatialTolerance:(SpatialTolerance *)st;
- (void)allowTemporalTolerance:(TemporalTolerance *)tt;

- (BOOL)isSpatiallyEqualAtStart:(NSArray *)start andEnd:(NSArray *)end;
- (BOOL)isTemporallyEqualAtStart:(NSTimeInterval)start andEnd:(NSTimeInterval)end;

@end


@interface Gesture : NSObject
{
    NSArray* frames;                          // series of frames that define the gesture
    NSUInteger curr_matched_frame;            // currently matched frame in array; 0 if no frames have been matched
    BOOL occurred;                            // true if the gesture occurred; false otherwise
    NSTimeInterval last_occurrence;           // timestamp from CPU when gesture last occurred -- not absolute
    UIAccelerationValue last_acceleration[3]; // values for the last updated acceleration
    NSTimeInterval last_acceleration_time;    // timestampe of last updated acceleration
    
    NSString* name;                            // gesture name
}

@property (nonatomic, retain) NSString* name;

- (id)init;
- (id)initWithFrames:(NSArray *)gesture_frames;
- (id)initWithFrames:(NSArray *)gesture_frames andName:(NSString *)gesture_name;

- (void)setFrames:(NSArray *)gesture_frames;

- (BOOL)didOccur;
- (BOOL)hasPartiallyOccurred;
- (NSUInteger)currentlyMatchedFrame;
- (NSTimeInterval)lastOccurrence;
- (NSUInteger)numFrames;
- (void)resetOccurrence;

- (void)updateWithX:(UIAccelerationValue)x withY:(UIAccelerationValue)y withZ:(UIAccelerationValue)z withTime:(NSTimeInterval)time;

@end


@protocol GestureTrackerDelegate

- (void)gestureOccurred:(Gesture *)gesture atTime:(NSTimeInterval)time;
- (void)gesturePartiallyOccurred:(Gesture *)gesture withCompletedFrames:(NSUInteger)frames atTime:(NSTimeInterval)time;
- (void)updatedAccelerationValues;

@end

@interface GestureTracker : NSObject <UIAccelerometerDelegate> 
{
    NSMutableSet* gestures;           // gestures to track
    UIAccelerationValue accel[3];     // acceleration values
    Filter* filter;                   // filter for acceleration values

    NSMutableSet* delegates;          // delegates for gesture occurrence
}

- (id)init;
- (void)dealloc;

- (void)configureAccelerometer:(int)updateInterval;

- (void)addGesture:(Gesture *)gesture;
- (void)deleteGesture:(Gesture *)gesture;

- (void)enableFiltering:(Filter *)filt;
- (void)disableFiltering;

- (NSArray *)getAccelerationValues;

- (void)addDelegate:(id <GestureTrackerDelegate>)new_delegate;
- (void)removeDelegate:(id <GestureTrackerDelegate>)rem_delegate;

@end