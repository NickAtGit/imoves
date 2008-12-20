//
//  Filter.h
//  iMoves
//
//  Created by Brian Wilke on 11/23/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in the "GPL License" folder as gpl.txt.

#import <UIKit/UIKit.h>


@interface Filter : NSObject 
{
@public
    
    UIAccelerationValue accel[3];  // acceleration values
}

- (id)init;
- (void)applyFilter:(UIAcceleration *)acceleration;

@end


@interface LowPassFilter : Filter
{
@public
    
    double low_pass_factor;
}

@end


@interface HighPassFilter : Filter
{
@public
    
    double high_pass_factor;
    
    UIAccelerationValue hist[3];  // low-pass history to feed into the high-pass filter
}

@end


@interface KalmanFilter : Filter
{

}

@end
