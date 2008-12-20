//
//  Tolerances.h
//  iMoves
//
//   Describes classes to deal with spatial tolerances in filtered/unfiltered accelerometer values
//
//  Created by Brian Wilke on 11/20/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in the "GPL License" folder as gpl.txt.

#import <UIKit/UIKit.h>


@interface Tolerance: NSObject
{

}

- (BOOL)withinTolerancesFromStart:(id)startPos toEnd:(id)endPos;

@end



@interface SpatialTolerance : Tolerance
{
@public
    
    UIAccelerationValue startSpec[3];
    UIAccelerationValue endSpec[3];
}

- (BOOL)withinTolerancesFromStart:(NSArray *)startPos toEnd:(NSArray *)endPos;

@end


@interface TemporalTolerance : Tolerance
{
@public
    
    NSTimeInterval delta;
}

- (BOOL)withinTolerancesFromStart:(NSTimeInterval)startTime toEnd:(NSTimeInterval)endTime;

@end



@interface CubicSpatialTolerance : SpatialTolerance
{
@public
    
    // tolerances -- specified as absolute (unsigned) numbers relative to the base positions
    //               maxes add to the base, mins subtract
    UIAccelerationValue startMax[3];
    UIAccelerationValue startMin[3];
    UIAccelerationValue endMax[3];
    UIAccelerationValue endMin[3];
}

@end


@interface SphericalSpatialTolerance : SpatialTolerance
{
@public
    
    // tolerances -- specified only as radius from specs
    double startRadius;
    double endRadius;
}

@end