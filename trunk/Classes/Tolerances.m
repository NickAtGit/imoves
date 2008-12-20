//
//  Tolerances.m
//  iMoves
//
//  Created by Brian Wilke on 11/20/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in the "GPL License" folder as gpl.txt.

#import "Tolerances.h"


@implementation Tolerance

- (BOOL)withinTolerancesFromStart:(id)startPos toEnd:(id)endPos
{
    return FALSE;
}

@end



@implementation SpatialTolerance

- (BOOL)withinTolerancesFromStart:(NSArray *)startPos toEnd:(NSArray *)endPos
{
    return FALSE;
}

@end


@implementation TemporalTolerance

- (BOOL)withinTolerancesFromStart:(NSTimeInterval)startTime toEnd:(NSTimeInterval)endTime
{
    NSTimeInterval dt = endTime - startTime;
    if(dt > delta)
    {
        return FALSE;
    }
    
    return TRUE;
}

@end



@implementation CubicSpatialTolerance

- (BOOL)withinTolerancesFromStart:(NSArray *)startPos toEnd:(NSArray *)endPos
{
    // check if startPos and/or endPos lie in a cube with center startSpec & endSpec,
    // and lengths startMax + startMin & endMax + endMin
    
    if((startPos == nil) && (endPos == nil))
    {
        return FALSE;
    }
    
    if(startPos != nil)
    {
        if([startPos count] != 3)
            return FALSE;
    }
    if(endPos != nil)
    {
        if([endPos count] != 3)
            return FALSE;
    }
    
    if(startPos != nil)
    {
        // test starting position
        if(([[startPos objectAtIndex:0] doubleValue] > (startSpec[0] + startMax[0])) ||
           ([[startPos objectAtIndex:0] doubleValue] < (startSpec[0] - startMin[0])))
        {
            return FALSE;
        }
        if(([[startPos objectAtIndex:1] doubleValue] > (startSpec[1] + startMax[1])) ||
           ([[startPos objectAtIndex:1] doubleValue] < (startSpec[1] - startMin[1])))
        {
            return FALSE;
        }
        if(([[startPos objectAtIndex:2] doubleValue] > (startSpec[2] + startMax[2])) ||
           ([[startPos objectAtIndex:2] doubleValue] < (startSpec[2] - startMin[2])))
        {
            return FALSE;
        }
    }
    
    if(endPos != nil)
    {
        // test ending position
        if(([[endPos objectAtIndex:0] doubleValue] > (endSpec[0] + endMax[0])) ||
           ([[endPos objectAtIndex:0] doubleValue] < (endSpec[0] - endMin[0])))
        {
            return FALSE;
        }
        if(([[endPos objectAtIndex:1] doubleValue] > (endSpec[1] + endMax[1])) ||
           ([[endPos objectAtIndex:1] doubleValue] < (endSpec[1] - endMin[1])))
        {
            return FALSE;
        }
        if(([[endPos objectAtIndex:2] doubleValue] > (endSpec[2] + endMax[2])) ||
           ([[endPos objectAtIndex:2] doubleValue] < (endSpec[2] - endMin[2])))
        {
            return FALSE;
        }
    }
    
    return TRUE;
}

@end


@implementation SphericalSpatialTolerance

- (BOOL)withinTolerancesFromStart:(NSArray *)startPos toEnd:(NSArray *)endPos
{
    // check if startPos and/or endPos lie in sphere defined by center startSpec & endSpec
    // and radii startRadius & endRadius
    
    if(startPos != nil)
    {
        if([startPos count] != 3)
            return FALSE;
    }
    if(endPos != nil)
    {
        if([endPos count] != 3)
            return FALSE;
    }
    
    if((startPos != nil) && (endPos != nil))
    {
        // test starting position
        double d = 0.0f;
        for(unsigned int i = 0; i < 3; i++)
        {
            d += pow([[startPos objectAtIndex:i] doubleValue] - startSpec[i], 2.0);
        }
        d = sqrt(d);
        if(d > startRadius)
        {
            return FALSE;
        }
        
        // test ending position
        d = 0.0f;
        for(unsigned int i = 0; i < 3; i++)
        {
            d += pow([[endPos objectAtIndex:i] doubleValue] - endSpec[i], 2.0);
        }
        d = sqrt(d);
        if(d > endRadius)
        {
            return FALSE;
        }
    }
    else if((startPos == nil) && (endPos != nil))
    {
        // test ending position
        double d = 0.0f;
        for(unsigned int i = 0; i < 3; i++)
        {
            d += pow([[endPos objectAtIndex:i] doubleValue] - endSpec[i], 2.0);
        }
        d = sqrt(d);
        if(d > endRadius)
        {
            return FALSE;
        }
    }
    else if((startPos != nil) && (endPos == nil))
    {
        // test starting position
        double d = 0.0f;
        for(unsigned int i = 0; i < 3; i++)
        {
            d += pow([[startPos objectAtIndex:i] doubleValue] - startSpec[i], 2.0);
        }
        d = sqrt(d);
        if(d > startRadius)
        {
            return FALSE;
        }
    }
    else // startPos == nil && endPos == nil
    {
        return FALSE;
    }
    
    return TRUE;
}

@end


