//
//  Gestures.m
//  iMoves
//
//  Created by Brian Wilke on 11/18/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in gpl.txt.

#import "Gestures.h"


@implementation Frame

- (id)init
{
    startPos[0] = 0.0;
    startPos[1] = 0.0;
    startPos[2] = 0.0;
    
    endPos[0] = 0.0;
    endPos[1] = 0.0;
    endPos[2] = 0.0;
    
    spatial_tolerance = nil;
    temporal_tolerance = nil;
    start_end_time_delta = 0;
    
    use_last_frame_end_as_start = FALSE;
    end_pos_relative_to_start = FALSE;
    
    return self;
}

- (void)dealloc
{
    if(spatial_tolerance != nil)
    {
        [spatial_tolerance release];
    }
    if(temporal_tolerance != nil)
    {
        [temporal_tolerance release];
    }
    
    [super dealloc];
}

- (void)allowSpatialTolerance:(SpatialTolerance *)st
{
    if(spatial_tolerance != nil)
    {
        [spatial_tolerance release];
    }
    
    spatial_tolerance = st;
    [spatial_tolerance retain];
}

- (void)allowTemporalTolerance:(TemporalTolerance *)tt
{
    if(temporal_tolerance != nil)
    {
        [temporal_tolerance release];
    }
    
    temporal_tolerance = tt;
    [temporal_tolerance retain];
}

- (BOOL)isSpatiallyEqualAtStart:(NSArray *)start andEnd:(NSArray *)end
{
    if([start count] != 3)
    {
        return FALSE;
    }
    if([end count] != 3)
    {
        return FALSE;
    }
    
    if(([[start objectAtIndex:0] doubleValue] == startPos[0]) &&
        ([[start objectAtIndex:1] doubleValue] == startPos[1]) &&
        ([[start objectAtIndex:2] doubleValue] == startPos[2]) &&
        ([[end objectAtIndex:0] doubleValue] == endPos[0]) &&
        ([[end objectAtIndex:1] doubleValue] == endPos[1]) &&
        ([[end objectAtIndex:2] doubleValue] == endPos[2]))
    {
        return TRUE;
    }
    
    return FALSE;
}

- (BOOL)isTemporallyEqualAtStart:(NSTimeInterval)start andEnd:(NSTimeInterval)end
{
    if((end - start) == start_end_time_delta)
    {
        return TRUE;
    }
    
    return FALSE;
}

@end


@implementation Gesture

@synthesize name;

- (id)init
{
    frames = nil;
    
    curr_matched_frame = 0;
    occurred = FALSE;
    last_occurrence = 0;

    last_acceleration[0] = 0.0f;
    last_acceleration[1] = 0.0f;
    last_acceleration[2] = 0.0f;
    last_acceleration_time = 0.0f;
    
    name = @"Unnamed";
    
    return self;
}

- (id)initWithFrames:(NSArray *)gesture_frames
{
    [self init];
    frames = [[NSArray alloc] initWithArray:gesture_frames];
    return self;
}

- (id)initWithFrames:(NSArray *)gesture_frames andName:(NSString *)gesture_name
{
    [self initWithFrames:gesture_frames];
    name = [[NSString alloc] initWithString:gesture_name];
    return self;
}

- (void)dealloc
{
    [frames release];
    
    [super dealloc];
}

- (void)setFrames:(NSArray *)gesture_frames
{
    if(frames != nil)
    {
        [frames release];
    }
    frames = [[NSArray alloc] initWithArray:gesture_frames];
}

- (BOOL)didOccur
{
    return occurred;
}

- (BOOL)hasPartiallyOccurred
{
    return (curr_matched_frame > 0);
}

- (NSUInteger)currentlyMatchedFrame
{
    return curr_matched_frame;
}

- (NSTimeInterval)lastOccurrence
{
    return last_occurrence;
}

- (NSUInteger)numFrames
{
    return [frames count];
}

- (void)resetOccurrence
{
    occurred = FALSE;
}

- (void)updateWithX:(UIAccelerationValue)x withY:(UIAccelerationValue)y withZ:(UIAccelerationValue)z withTime:(NSTimeInterval)time
{
    if(frames == nil)
    {
        return;
    }
    
    // check next frame to see if it falls within new values
    NSArray *start = nil, *end = nil;
    
    Frame *next_frame = [frames objectAtIndex:curr_matched_frame];
    if(next_frame == nil)
    {
        return;
    }
    
    if(next_frame->use_last_frame_end_as_start)
    {
        if(next_frame->end_pos_relative_to_start)
        {
            // ending position specified as delta of last position
            // don't care about starting position
            NSNumber* accelX = [[NSNumber alloc] initWithDouble:(x - last_acceleration[0])];
            NSNumber* accelY = [[NSNumber alloc] initWithDouble:(y - last_acceleration[1])];
            NSNumber* accelZ = [[NSNumber alloc] initWithDouble:(z - last_acceleration[2])];
            
            end = [[NSArray alloc] initWithObjects:accelX, accelY, accelZ, nil];
            
            // NSArray maintains strong reference, so we can deallocate objects here to ensure
            // they're deallocated when arrays are deallocated
            [accelX release];
            [accelY release];
            [accelZ release];
        }
        else
        {
            // don't care about starting position, only care about current position
            NSNumber* accelX = [[NSNumber alloc] initWithDouble:x];
            NSNumber* accelY = [[NSNumber alloc] initWithDouble:y];
            NSNumber* accelZ = [[NSNumber alloc] initWithDouble:z];
            
            end = [[NSArray alloc] initWithObjects:accelX, accelY, accelZ, nil];
            
            // NSArray maintains strong reference, so we can deallocate objects here to ensure
            // they're deallocated when arrays are deallocated
            [accelX release];
            [accelY release];
            [accelZ release];
        }
    }
    else
    {
        if(next_frame->end_pos_relative_to_start)
        {
            // ending position specified as delta of last position
            // but we care about the starting position
            NSNumber* sAccelX = [[NSNumber alloc] initWithDouble:last_acceleration[0]];
            NSNumber* sAccelY = [[NSNumber alloc] initWithDouble:last_acceleration[1]];
            NSNumber* sAccelZ = [[NSNumber alloc] initWithDouble:last_acceleration[2]];
            
            NSNumber* eAccelX = [[NSNumber alloc] initWithDouble:(x - last_acceleration[0])];
            NSNumber* eAccelY = [[NSNumber alloc] initWithDouble:(y - last_acceleration[1])];
            NSNumber* eAccelZ = [[NSNumber alloc] initWithDouble:(z - last_acceleration[2])];
            
            start = [[NSArray alloc] initWithObjects:sAccelX, sAccelY, sAccelZ, nil];
            end = [[NSArray alloc] initWithObjects:eAccelX, eAccelY, eAccelZ, nil];
            
            // NSArray maintains strong reference, so we can deallocate objects here to ensure
            // they're deallocated when arrays are deallocated
            [sAccelX release];
            [sAccelY release];
            [sAccelZ release];
            [eAccelX release];
            [eAccelY release];
            [eAccelZ release];
        }
        else
        {
            // care about absolute starting position and ending position
            NSNumber* sAccelX = [[NSNumber alloc] initWithDouble:last_acceleration[0]];
            NSNumber* sAccelY = [[NSNumber alloc] initWithDouble:last_acceleration[1]];
            NSNumber* sAccelZ = [[NSNumber alloc] initWithDouble:last_acceleration[2]];
            
            NSNumber* eAccelX = [[NSNumber alloc] initWithDouble:x];
            NSNumber* eAccelY = [[NSNumber alloc] initWithDouble:y];
            NSNumber* eAccelZ = [[NSNumber alloc] initWithDouble:z];
            
            start = [[NSArray alloc] initWithObjects:sAccelX, sAccelY, sAccelZ, nil];
            end = [[NSArray alloc] initWithObjects:eAccelX, eAccelY, eAccelZ, nil];
            
            // NSArray maintains strong reference, so we can deallocate objects here to ensure
            // they're deallocated when arrays are deallocated
            [sAccelX release];
            [sAccelY release];
            [sAccelZ release];
            [eAccelX release];
            [eAccelY release];
            [eAccelZ release];
        }
    }
    
    BOOL spatial_matched = FALSE;
    if(next_frame->spatial_tolerance != nil)
    {
        spatial_matched = [next_frame->spatial_tolerance withinTolerancesFromStart:start toEnd:end];
    }
    else
    {
        spatial_matched = [next_frame isSpatiallyEqualAtStart:start andEnd:end];
    }
    
    BOOL temporal_matched = FALSE;
    if(next_frame->temporal_tolerance != nil)
    {
        temporal_matched = [next_frame->temporal_tolerance withinTolerancesFromStart:last_acceleration_time toEnd:time];
    }
    else
    {
        temporal_matched = [next_frame isTemporallyEqualAtStart:last_acceleration_time andEnd:time];
    }
    
    if(spatial_matched && temporal_matched)
    {
        curr_matched_frame++;
        if(curr_matched_frame == [frames count])
        {
            occurred = TRUE;
            last_occurrence = time;
            curr_matched_frame = 0;
        }
        
        // adjust last acceleration values
        last_acceleration[0] = x;
        last_acceleration[1] = y;
        last_acceleration[2] = z;
        last_acceleration_time = time;
    }
    // can match temporally and not spatially, but cannot match spatially and not temporally
    else if(!temporal_matched)
    {
        occurred = FALSE;
        curr_matched_frame = 0;
        
        // adjust last acceleration values
        last_acceleration[0] = x;
        last_acceleration[1] = y;
        last_acceleration[2] = z;
        last_acceleration_time = time;
    }
    
    if(start != nil)
    {
        [start release];
    }
    if(end != nil)
    {
        [end release];
    }
}

@end

@implementation GestureTracker

- (id)init
{
    gestures = [[NSMutableSet alloc] init];
    
    filter = nil;
    
    accel[0] = 0.0f;
    accel[1] = 0.0f;
    accel[2] = 0.0f;
    
    delegates = [[NSMutableSet alloc] init];
    
    return self;
}

- (void)dealloc
{
    [gestures release];
    
    if(filter != nil)
    {
        [filter release];
    }
    
    [super dealloc];
}

- (void)configureAccelerometer:(int)updateInterval
{
    UIAccelerometer* theAccelerometer = [UIAccelerometer sharedAccelerometer];
    theAccelerometer.updateInterval = updateInterval;
    
    theAccelerometer.delegate = self;
}

- (void)enableFiltering:(Filter *)filt
{
    if(filter != nil)
    {
        [filter release];
    }
    
    filter = filt;
    [filter retain];
}

- (void)disableFiltering
{
    if(filter != nil)
    {
        [filter release];
        filter = nil;
    }
}

- (NSArray *)getAccelerationValues
{
    return [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithDouble:accel[0]], 
            [[NSNumber alloc] initWithDouble:accel[1]], [[NSNumber alloc] initWithDouble:accel[2]], nil];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    // apply filtering before updating gestures
    if(filter != nil)
    {
        [filter applyFilter:acceleration];
        accel[0] = filter->accel[0];
        accel[1] = filter->accel[1];
        accel[2] = filter->accel[2];
    }
    else
    {
        accel[0] = acceleration.x;
        accel[1] = acceleration.y;
        accel[2] = acceleration.z;
    }
    
    for(Gesture* gesture in gestures)
    {
        [gesture updateWithX:accel[0] withY:accel[1] withZ:accel[2] withTime:acceleration.timestamp];
        if([gesture didOccur])
        {
            // send out message to delegates that gesture occurred
            for(id delegate in delegates)
            {
                [delegate gestureOccurred:gesture atTime:acceleration.timestamp];
            }
            
            [gesture resetOccurrence];
        }
        else if([gesture hasPartiallyOccurred])
        {
            // send out message to delegates that gesture partially occurred
            for(id delegate in delegates)
            {
                [delegate gesturePartiallyOccurred:gesture withCompletedFrames:[gesture currentlyMatchedFrame] atTime:acceleration.timestamp];
            }
        }
    }
    
    for(id delegate in delegates)
    {
        [delegate updatedAccelerationValues];
    }
}

- (void)addGesture:(Gesture *)gesture
{
    if(gesture != nil)
    {
        [gestures addObject:gesture];
    }
}

- (void)deleteGesture:(Gesture *)gesture
{
    if(gesture != nil)
    {
        [gestures removeObject:gesture];
    }
}

- (void)addDelegate:(id <GestureTrackerDelegate>)new_delegate
{
    [delegates addObject:new_delegate];
}

- (void)removeDelegate:(id <GestureTrackerDelegate>)rem_delegate
{
    [delegates removeObject:rem_delegate];
}

@end

