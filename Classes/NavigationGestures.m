//
//  NavigationGestures.m
//  iMoves
//
//  Created by Brian Wilke on 11/24/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in the "GPL License" folder as gpl.txt.

#import "NavigationGestures.h"


@implementation NavigationGestures

// default to 40 times/sec accelerometer sample rate
#define defaultFrequency     40

// default high pass factor to 0.1
#define defaultHpf           0.1

// max/min acceleration values
#define maxAcceleration      4.0
#define minAcceleration      -4.0

// synthetics
@synthesize tracker;
@synthesize scroll_up;
@synthesize scroll_down;
@synthesize go_forward;
@synthesize go_backward;

// gesture creation

+ (Gesture *)createScrollUpGesture
{
    // create scrolling up, assuming we're filtering orientation
    
    // make sure first frame will always match
    Frame *scroll_up_1 = [[Frame alloc] init];
    scroll_up_1->use_last_frame_end_as_start = FALSE;
    scroll_up_1->end_pos_relative_to_start = FALSE;
    scroll_up_1->startPos[0] = 0.0;
    scroll_up_1->startPos[1] = 0.0;
    scroll_up_1->startPos[2] = 0.0;
    scroll_up_1->endPos[0] = 0.0;
    scroll_up_1->endPos[1] = 0.0;
    scroll_up_1->endPos[2] = 0.0;
    
    CubicSpatialTolerance *scroll_up_1_stol = [CubicSpatialTolerance alloc];
    scroll_up_1_stol->startSpec[0] = 0.0;
    scroll_up_1_stol->startSpec[1] = 0.0;
    scroll_up_1_stol->startSpec[2] = 0.0;
    scroll_up_1_stol->endSpec[0] = 0.0;
    scroll_up_1_stol->endSpec[1] = 0.0;
    scroll_up_1_stol->endSpec[2] = 0.0;
    
    scroll_up_1_stol->startMax[0] = maxAcceleration;
    scroll_up_1_stol->startMin[0] = maxAcceleration;
    scroll_up_1_stol->startMax[1] = maxAcceleration;
    scroll_up_1_stol->startMin[1] = maxAcceleration;
    scroll_up_1_stol->startMax[2] = maxAcceleration;
    scroll_up_1_stol->startMin[2] = maxAcceleration;
    scroll_up_1_stol->endMax[0] = maxAcceleration;
    scroll_up_1_stol->endMin[0] = maxAcceleration;
    scroll_up_1_stol->endMax[1] = maxAcceleration;
    scroll_up_1_stol->endMin[1] = maxAcceleration;
    scroll_up_1_stol->endMax[2] = maxAcceleration;
    scroll_up_1_stol->endMin[2] = maxAcceleration;
    
    TemporalTolerance *scroll_up_1_ttol = [TemporalTolerance alloc];
    scroll_up_1_ttol->delta = 1.0;
    
    [scroll_up_1 allowSpatialTolerance:scroll_up_1_stol];
    [scroll_up_1 allowTemporalTolerance:scroll_up_1_ttol];
    [scroll_up_1_stol release];
    [scroll_up_1_ttol release];
    
    // frame 2 is a negative movement along the z-axis and positive movement along the y-axis
    // x-axis should remain relatively stable
    Frame *scroll_up_2 = [[Frame alloc] init];
    scroll_up_2->use_last_frame_end_as_start = TRUE;
    scroll_up_2->end_pos_relative_to_start = TRUE;
    scroll_up_2->endPos[0] = 0.0;
    scroll_up_2->endPos[1] = +0.1;
    scroll_up_2->endPos[2] = -0.7;
    
    CubicSpatialTolerance *scroll_up_2_stol = [CubicSpatialTolerance alloc];
    scroll_up_2_stol->endSpec[0] = 0.0;
    scroll_up_2_stol->endSpec[1] = +0.1;
    scroll_up_2_stol->endSpec[2] = -0.7;
    
    scroll_up_2_stol->endMax[0] = 0.3;
    scroll_up_2_stol->endMin[0] = 0.3;
    scroll_up_2_stol->endMax[1] = 0.9;
    scroll_up_2_stol->endMin[1] = 0.0;
    scroll_up_2_stol->endMax[2] = 0.2;
    scroll_up_2_stol->endMin[2] = 2.3;
    
    TemporalTolerance *scroll_up_2_ttol = [TemporalTolerance alloc];
    scroll_up_2_ttol->delta = 1.0;
    
    [scroll_up_2 allowSpatialTolerance:scroll_up_2_stol];
    [scroll_up_2 allowTemporalTolerance:scroll_up_2_ttol];
    [scroll_up_2_stol release];
    [scroll_up_2_ttol release];

    // frame 3 is a return -- a positive movement along the z-axis and negative movement along the y-axis
    Frame *scroll_up_3 = [[Frame alloc] init];
    scroll_up_3->use_last_frame_end_as_start = TRUE;
    scroll_up_3->end_pos_relative_to_start = TRUE;
    scroll_up_3->endPos[0] = 0.0;
    scroll_up_3->endPos[1] = -0.1;
    scroll_up_3->endPos[2] = +0.7;
    
    CubicSpatialTolerance *scroll_up_3_stol = [CubicSpatialTolerance alloc];
    scroll_up_3_stol->endSpec[0] = 0.0;
    scroll_up_3_stol->endSpec[1] = -0.1;
    scroll_up_3_stol->endSpec[2] = +0.7;
    
    scroll_up_3_stol->endMax[0] = 0.3;
    scroll_up_3_stol->endMin[0] = 0.3;
    scroll_up_3_stol->endMax[1] = 0.0;
    scroll_up_3_stol->endMin[1] = 0.9;
    scroll_up_3_stol->endMax[2] = 2.3;
    scroll_up_3_stol->endMin[2] = 0.2;
    
    TemporalTolerance *scroll_up_3_ttol = [TemporalTolerance alloc];
    scroll_up_3_ttol->delta = 1.0;
    
    [scroll_up_3 allowSpatialTolerance:scroll_up_3_stol];
    [scroll_up_3 allowTemporalTolerance:scroll_up_3_ttol];
    [scroll_up_3_stol release];
    [scroll_up_3_ttol release];
    
    NSArray* arr = [[NSArray alloc] initWithObjects:scroll_up_1, scroll_up_2, scroll_up_3, nil];
    Gesture* su = [[Gesture alloc] initWithFrames:arr andName:@"Scroll Up"];
    [arr release];
    
    return su;
}

+ (Gesture *)createScrollDownGesture
{
    // create scrolling down, assuming we're filtering orientation
    
    // make sure first frame will always match
    Frame *scroll_down_1 = [[Frame alloc] init];
    scroll_down_1->use_last_frame_end_as_start = TRUE;
    scroll_down_1->end_pos_relative_to_start = FALSE;
    scroll_down_1->startPos[0] = 0.0;
    scroll_down_1->startPos[1] = 0.0;
    scroll_down_1->startPos[2] = 0.0;
    scroll_down_1->endPos[0] = 0.0;
    scroll_down_1->endPos[1] = 0.0;
    scroll_down_1->endPos[2] = 0.0;
    
    CubicSpatialTolerance *scroll_down_1_stol = [CubicSpatialTolerance alloc];
    scroll_down_1_stol->startSpec[0] = 0.0;
    scroll_down_1_stol->startSpec[1] = 0.0;
    scroll_down_1_stol->startSpec[2] = 0.0;
    scroll_down_1_stol->endSpec[0] = 0.0;
    scroll_down_1_stol->endSpec[1] = 0.0;
    scroll_down_1_stol->endSpec[2] = 0.0;
    
    scroll_down_1_stol->startMax[0] = maxAcceleration;
    scroll_down_1_stol->startMin[0] = maxAcceleration;
    scroll_down_1_stol->startMax[1] = maxAcceleration;
    scroll_down_1_stol->startMin[1] = maxAcceleration;
    scroll_down_1_stol->startMax[2] = maxAcceleration;
    scroll_down_1_stol->startMin[2] = maxAcceleration;
    scroll_down_1_stol->endMax[0] = maxAcceleration;
    scroll_down_1_stol->endMin[0] = maxAcceleration;
    scroll_down_1_stol->endMax[1] = maxAcceleration;
    scroll_down_1_stol->endMin[1] = maxAcceleration;
    scroll_down_1_stol->endMax[2] = maxAcceleration;
    scroll_down_1_stol->endMin[2] = maxAcceleration;
    
    TemporalTolerance *scroll_down_1_ttol = [TemporalTolerance alloc];
    scroll_down_1_ttol->delta = 0.6;
    
    [scroll_down_1 allowSpatialTolerance:scroll_down_1_stol];
    [scroll_down_1 allowTemporalTolerance:scroll_down_1_ttol];
    [scroll_down_1_stol release];
    [scroll_down_1_ttol release];
    
    // frame 2 is a positive movement along the z-axis and a negative movement along the y-axis
    // x-axis should remain relatively stable
    Frame *scroll_down_2 = [[Frame alloc] init];
    scroll_down_2->use_last_frame_end_as_start = TRUE;
    scroll_down_2->end_pos_relative_to_start = TRUE;
    scroll_down_2->endPos[0] = 0.0;
    scroll_down_2->endPos[1] = -0.1;
    scroll_down_2->endPos[2] = +0.7;
    
    CubicSpatialTolerance *scroll_down_2_stol = [CubicSpatialTolerance alloc];
    scroll_down_2_stol->endSpec[0] = 0.0;
    scroll_down_2_stol->endSpec[1] = -0.1;
    scroll_down_2_stol->endSpec[2] = +0.7;
    
    scroll_down_2_stol->endMax[0] = 0.3;
    scroll_down_2_stol->endMin[0] = 0.3;
    scroll_down_2_stol->endMax[1] = 0.0;
    scroll_down_2_stol->endMin[1] = 1.5;
    scroll_down_2_stol->endMax[2] = 2.3;
    scroll_down_2_stol->endMin[2] = 0.3;
    
    TemporalTolerance *scroll_down_2_ttol = [TemporalTolerance alloc];
    scroll_down_2_ttol->delta = 1.0;
    
    [scroll_down_2 allowSpatialTolerance:scroll_down_2_stol];
    [scroll_down_2 allowTemporalTolerance:scroll_down_2_ttol];
    [scroll_down_2_stol release];
    [scroll_down_2_ttol release];
    
    // frame 3 is a return -- a negative movement along the z-axis and positive movement along the y-axis
    Frame *scroll_down_3 = [[Frame alloc] init];
    scroll_down_3->use_last_frame_end_as_start = TRUE;
    scroll_down_3->end_pos_relative_to_start = TRUE;
    scroll_down_3->endPos[0] = 0.0;
    scroll_down_3->endPos[1] = +0.1;
    scroll_down_3->endPos[2] = -0.7;
    
    CubicSpatialTolerance *scroll_down_3_stol = [CubicSpatialTolerance alloc];
    scroll_down_3_stol->endSpec[0] = 0.0;
    scroll_down_3_stol->endSpec[1] = 0.0;
    scroll_down_3_stol->endSpec[2] = -0.7;
    
    scroll_down_3_stol->endMax[0] = 0.3;
    scroll_down_3_stol->endMin[0] = 0.3;
    scroll_down_3_stol->endMax[1] = 1.5;
    scroll_down_3_stol->endMin[1] = 0.0;
    scroll_down_3_stol->endMax[2] = 0.3;
    scroll_down_3_stol->endMin[2] = 2.3;
    
    TemporalTolerance *scroll_down_3_ttol = [TemporalTolerance alloc];
    scroll_down_3_ttol->delta = 1.0;
    
    [scroll_down_3 allowSpatialTolerance:scroll_down_3_stol];
    [scroll_down_3 allowTemporalTolerance:scroll_down_3_ttol];
    [scroll_down_3_stol release];
    [scroll_down_3_ttol release];
    
    NSArray* arr = [[NSArray alloc] initWithObjects:scroll_down_1, scroll_down_2, scroll_down_3, nil];
    Gesture* su = [[Gesture alloc] initWithFrames:arr andName:@"Scroll Down"];
    [arr release];
    
    return su;
}

+ (Gesture *)createGoForwardGesture
{
    // create going forward, assuming we're filtering orientation
    
    // make sure first frame will always match
    Frame *go_forward_1 = [[Frame alloc] init];
    go_forward_1->use_last_frame_end_as_start = TRUE;
    go_forward_1->end_pos_relative_to_start = FALSE;
    go_forward_1->startPos[0] = 0.0;
    go_forward_1->startPos[1] = 0.0;
    go_forward_1->startPos[2] = 0.0;
    go_forward_1->endPos[0] = 0.0;
    go_forward_1->endPos[1] = 0.0;
    go_forward_1->endPos[2] = 0.0;
    
    CubicSpatialTolerance *go_forward_1_stol = [CubicSpatialTolerance alloc];
    go_forward_1_stol->startSpec[0] = 0.0;
    go_forward_1_stol->startSpec[1] = 0.0;
    go_forward_1_stol->startSpec[2] = 0.0;
    go_forward_1_stol->endSpec[0] = 0.0;
    go_forward_1_stol->endSpec[1] = 0.0;
    go_forward_1_stol->endSpec[2] = 0.0;
    
    go_forward_1_stol->startMax[0] = maxAcceleration;
    go_forward_1_stol->startMin[0] = maxAcceleration;
    go_forward_1_stol->startMax[1] = maxAcceleration;
    go_forward_1_stol->startMin[1] = maxAcceleration;
    go_forward_1_stol->startMax[2] = maxAcceleration;
    go_forward_1_stol->startMin[2] = maxAcceleration;
    go_forward_1_stol->endMax[0] = maxAcceleration;
    go_forward_1_stol->endMin[0] = maxAcceleration;
    go_forward_1_stol->endMax[1] = maxAcceleration;
    go_forward_1_stol->endMin[1] = maxAcceleration;
    go_forward_1_stol->endMax[2] = maxAcceleration;
    go_forward_1_stol->endMin[2] = maxAcceleration;
    
    TemporalTolerance *go_forward_1_ttol = [TemporalTolerance alloc];
    go_forward_1_ttol->delta = 1.0;
    
    [go_forward_1 allowSpatialTolerance:go_forward_1_stol];
    [go_forward_1 allowTemporalTolerance:go_forward_1_ttol];
    [go_forward_1_stol release];
    [go_forward_1_ttol release];
    
    // frame 2 is a positive movement along the x-axis
    // y-axis and z-axis should remain relatively stable, but z-axis could change depending
    // on which hand is being used
    Frame *go_forward_2 = [[Frame alloc] init];
    go_forward_2->use_last_frame_end_as_start = TRUE;
    go_forward_2->end_pos_relative_to_start = TRUE;
    go_forward_2->endPos[0] = +0.5;
    go_forward_2->endPos[1] = 0.0;
    go_forward_2->endPos[2] = 0.0;
    
    CubicSpatialTolerance *go_forward_2_stol = [CubicSpatialTolerance alloc];
    go_forward_2_stol->endSpec[0] = +0.5;
    go_forward_2_stol->endSpec[1] = 0.0;
    go_forward_2_stol->endSpec[2] = 0.0;
    
    go_forward_2_stol->endMax[0] = 1.0;
    go_forward_2_stol->endMin[0] = 0.1;
    go_forward_2_stol->endMax[1] = 0.3;
    go_forward_2_stol->endMin[1] = 0.3;
    go_forward_2_stol->endMax[2] = 1.0;
    go_forward_2_stol->endMin[2] = 1.0;
    
    TemporalTolerance *go_forward_2_ttol = [TemporalTolerance alloc];
    go_forward_2_ttol->delta = 1.0;
    
    [go_forward_2 allowSpatialTolerance:go_forward_2_stol];
    [go_forward_2 allowTemporalTolerance:go_forward_2_ttol];
    [go_forward_2_stol release];
    [go_forward_2_ttol release];
    
    // frame 3 is a return -- a negative movement along the x-axis
    Frame *go_forward_3 = [[Frame alloc] init];
    go_forward_3->use_last_frame_end_as_start = TRUE;
    go_forward_3->end_pos_relative_to_start = TRUE;
    go_forward_3->endPos[0] = -0.5;
    go_forward_3->endPos[1] = 0.0;
    go_forward_3->endPos[2] = 0.0;
    
    CubicSpatialTolerance *go_forward_3_stol = [CubicSpatialTolerance alloc];
    go_forward_3_stol->endSpec[0] = -0.5;
    go_forward_3_stol->endSpec[1] = 0.0;
    go_forward_3_stol->endSpec[2] = 0.0;
    
    go_forward_3_stol->endMax[0] = 0.1;
    go_forward_3_stol->endMin[0] = 1.0;
    go_forward_3_stol->endMax[1] = 0.3;
    go_forward_3_stol->endMin[1] = 0.3;
    go_forward_3_stol->endMax[2] = 1.0;
    go_forward_3_stol->endMin[2] = 1.0;
    
    TemporalTolerance *go_forward_3_ttol = [TemporalTolerance alloc];
    go_forward_3_ttol->delta = 1.0;
    
    [go_forward_3 allowSpatialTolerance:go_forward_3_stol];
    [go_forward_3 allowTemporalTolerance:go_forward_3_ttol];
    [go_forward_3_stol release];
    [go_forward_3_ttol release];
    
    NSArray* arr = [[NSArray alloc] initWithObjects:go_forward_1, go_forward_2, go_forward_3, nil];
    Gesture* gf = [[Gesture alloc] initWithFrames:arr andName:@"Go Forward"];
    [arr release];
    
    return gf;
}

+ (Gesture *)createGoBackwardGesture
{
    // create going backward, assuming we're filtering orientation

    // make sure first frame will always match
    Frame *go_backward_1 = [[Frame alloc] init];
    go_backward_1->use_last_frame_end_as_start = TRUE;
    go_backward_1->end_pos_relative_to_start = FALSE;
    go_backward_1->startPos[0] = 0.0;
    go_backward_1->startPos[1] = 0.0;
    go_backward_1->startPos[2] = 0.0;
    go_backward_1->endPos[0] = 0.0;
    go_backward_1->endPos[1] = 0.0;
    go_backward_1->endPos[2] = 0.0;
    
    CubicSpatialTolerance *go_backward_1_stol = [CubicSpatialTolerance alloc];
    go_backward_1_stol->startSpec[0] = 0.0;
    go_backward_1_stol->startSpec[1] = 0.0;
    go_backward_1_stol->startSpec[2] = 0.0;
    go_backward_1_stol->endSpec[0] = 0.0;
    go_backward_1_stol->endSpec[1] = 0.0;
    go_backward_1_stol->endSpec[2] = 0.0;
    
    go_backward_1_stol->startMax[0] = maxAcceleration;
    go_backward_1_stol->startMin[0] = maxAcceleration;
    go_backward_1_stol->startMax[1] = maxAcceleration;
    go_backward_1_stol->startMin[1] = maxAcceleration;
    go_backward_1_stol->startMax[2] = maxAcceleration;
    go_backward_1_stol->startMin[2] = maxAcceleration;
    go_backward_1_stol->endMax[0] = maxAcceleration;
    go_backward_1_stol->endMin[0] = maxAcceleration;
    go_backward_1_stol->endMax[1] = maxAcceleration;
    go_backward_1_stol->endMin[1] = maxAcceleration;
    go_backward_1_stol->endMax[2] = maxAcceleration;
    go_backward_1_stol->endMin[2] = maxAcceleration;
    
    TemporalTolerance *go_backward_1_ttol = [TemporalTolerance alloc];
    go_backward_1_ttol->delta = 1.0;
    
    [go_backward_1 allowSpatialTolerance:go_backward_1_stol];
    [go_backward_1 allowTemporalTolerance:go_backward_1_ttol];
    [go_backward_1_stol release];
    [go_backward_1_ttol release];
    
    // frame 2 is a negative movement along the x-axis
    // y-axis and z-axis should remain relatively stable, but z-axis could change depending
    // on which hand is being used
    Frame *go_backward_2 = [[Frame alloc] init];
    go_backward_2->use_last_frame_end_as_start = TRUE;
    go_backward_2->end_pos_relative_to_start = TRUE;
    go_backward_2->endPos[0] = -0.5;
    go_backward_2->endPos[1] = 0.0;
    go_backward_2->endPos[2] = 0.0;
    
    CubicSpatialTolerance *go_backward_2_stol = [CubicSpatialTolerance alloc];
    go_backward_2_stol->endSpec[0] = -0.5;
    go_backward_2_stol->endSpec[1] = 0.0;
    go_backward_2_stol->endSpec[2] = 0.0;
    
    go_backward_2_stol->endMax[0] = 0.1;
    go_backward_2_stol->endMin[0] = 1.0;
    go_backward_2_stol->endMax[1] = 0.3;
    go_backward_2_stol->endMin[1] = 0.3;
    go_backward_2_stol->endMax[2] = 1.0;
    go_backward_2_stol->endMin[2] = 1.0;
    
    TemporalTolerance *go_backward_2_ttol = [TemporalTolerance alloc];
    go_backward_2_ttol->delta = 1.0;
    
    [go_backward_2 allowSpatialTolerance:go_backward_2_stol];
    [go_backward_2 allowTemporalTolerance:go_backward_2_ttol];
    [go_backward_2_stol release];
    [go_backward_2_ttol release];
    
    // frame 3 is a return -- a positive movement along the x-axis
    Frame *go_backward_3 = [[Frame alloc] init];
    go_backward_3->use_last_frame_end_as_start = TRUE;
    go_backward_3->end_pos_relative_to_start = TRUE;
    go_backward_3->endPos[0] = +0.5;
    go_backward_3->endPos[1] = 0.0;
    go_backward_3->endPos[2] = 0.0;
    
    CubicSpatialTolerance *go_backward_3_stol = [CubicSpatialTolerance alloc];
    go_backward_3_stol->endSpec[0] = +0.5;
    go_backward_3_stol->endSpec[1] = 0.0;
    go_backward_3_stol->endSpec[2] = 0.0;
    
    go_backward_3_stol->endMax[0] = 1.0;
    go_backward_3_stol->endMin[0] = 0.1;
    go_backward_3_stol->endMax[1] = 0.3;
    go_backward_3_stol->endMin[1] = 0.3;
    go_backward_3_stol->endMax[2] = 1.0;
    go_backward_3_stol->endMin[2] = 1.0;
    
    TemporalTolerance *go_backward_3_ttol = [TemporalTolerance alloc];
    go_backward_3_ttol->delta = 1.0;
    
    [go_backward_3 allowSpatialTolerance:go_backward_3_stol];
    [go_backward_3 allowTemporalTolerance:go_backward_3_ttol];
    [go_backward_3_stol release];
    [go_backward_3_ttol release];
    
    NSArray* arr = [[NSArray alloc] initWithObjects:go_backward_1, go_backward_2, go_backward_3, nil];
    Gesture* gb = [[Gesture alloc] initWithFrames:arr andName:@"Go Backwards"];
    [arr release];
    
    return gb;
}

// initialization
- (id)init
{
    tracker = [[GestureTracker alloc] init];
    [tracker addDelegate:self];
    
    // don't care about orientation -- only movement
    hpf = [[HighPassFilter alloc] init];
    hpf->high_pass_factor = defaultHpf;
    [tracker enableFiltering:hpf];
    
    // create gestures
    //scroll_up = [NavigationGestures createScrollUpGesture];
    scroll_down = [NavigationGestures createScrollDownGesture];
    go_forward = [NavigationGestures createGoForwardGesture];
    go_backward = [NavigationGestures createGoBackwardGesture];
    
    // add gestures to tracker
    //[tracker addGesture:scroll_up];
    [tracker addGesture:scroll_down];
    [tracker addGesture:go_forward];
    [tracker addGesture:go_backward];
    
    [tracker configureAccelerometer:(1.0 / defaultFrequency)];
    
    delegate = nil;
    
    return self;
}

- (id)initWithUpdateInterval:(double)updateInterval andHighPassFilterFactor:(double)factor
{
    tracker = [[GestureTracker alloc] init];
    [tracker addDelegate:self];
    
    // don't care about orientation -- only movement
    hpf = [[HighPassFilter alloc] init];
    hpf->high_pass_factor = factor;
    [tracker enableFiltering:hpf];
    
    // create gestures
    scroll_up = [NavigationGestures createScrollUpGesture];
    //scroll_down = [NavigationGestures createScrollDownGesture];
    go_forward = [NavigationGestures createGoForwardGesture];
    go_backward = [NavigationGestures createGoBackwardGesture];
    
    // add gestures to tracker
    //[tracker addGesture:scroll_up];
    [tracker addGesture:scroll_down];
    [tracker addGesture:go_forward];
    [tracker addGesture:go_backward];
    
    [tracker configureAccelerometer:updateInterval];
    
    delegate = nil;
    
    return self;
}

- (id)initWithUpdateFrequency:(double)updateFrequency andHighPassFilterFactor:(double)factor
{
    [self initWithUpdateInterval:(1.0 / updateFrequency) andHighPassFilterFactor:factor];
    
    return self;
}

- (void)setDelegate:(id <NavigationGestureDelegate>)new_delegate
{
    delegate = new_delegate;
}

- (void)unsetDelegate
{
    delegate = nil;
}

- (void)dealloc
{
    [tracker removeDelegate:self];
    
    [scroll_up release];
    [scroll_down release];
    [go_forward release];
    [go_backward release];
    [tracker release];
    
    [hpf release];
    
    [super dealloc];
}

- (void)gestureOccurred:(Gesture *)gesture atTime:(NSTimeInterval)time
{
    if(delegate == nil)
    {
        return;
    }
    
    if(gesture == scroll_up)
    {
        [delegate scrollUp];
    }
    else if(gesture == scroll_down)
    {
        [delegate scrollDown];
    }
    else if(gesture == go_forward)
    {
        [delegate goForward];
    }
    else if(gesture == go_backward)
    {
        [delegate goBackward];
    }
}

- (void)gesturePartiallyOccurred:(Gesture *)gesture withCompletedFrames:(NSUInteger)frames atTime:(NSTimeInterval)time
{
}

- (void)updatedAccelerationValues
{
}

@end
