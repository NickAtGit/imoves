//
//  Filter.m
//  iMoves
//
//  Created by Brian Wilke on 11/23/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in the "GPL License" folder as gpl.txt.

#import "Filter.h"


@implementation Filter

- (id)init
{
    accel[0] = 0.0;
    accel[1] = 0.0;
    accel[2] = 0.0;
    
    return self;
}

- (void)applyFilter:(UIAcceleration *)acceleration
{
}

@end


@implementation LowPassFilter

- (void)applyFilter:(UIAcceleration *)acceleration
{
    // basic low-pass filter
    accel[0] = acceleration.x * low_pass_factor + accel[0] * (1.0f - low_pass_factor);
    accel[1] = acceleration.y * low_pass_factor + accel[1] * (1.0f - low_pass_factor);
    accel[2] = acceleration.z * low_pass_factor + accel[2] * (1.0f - low_pass_factor);
}

@end


@implementation HighPassFilter

- (id)init
{
    hist[0] = 0.0;
    hist[1] = 0.0;
    hist[2] = 0.0;
    
    [super init];
    
    return self;
}

- (void)applyFilter:(UIAcceleration *)acceleration
{
    // basic high-pass filter
    
    hist[0] = acceleration.x * high_pass_factor + hist[0] * (1.0f - high_pass_factor);
    hist[1] = acceleration.y * high_pass_factor + hist[1] * (1.0f - high_pass_factor);
    hist[2] = acceleration.z * high_pass_factor + hist[2] * (1.0f - high_pass_factor);
    
    accel[0] = acceleration.x - hist[0];
    accel[1] = acceleration.y - hist[1];
    accel[2] = acceleration.z - hist[2];
}


@end