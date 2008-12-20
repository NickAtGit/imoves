//
//  GestureVisualizer.m
//  iMoves
//
//  Created by Brian Wilke on 12/7/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in the "GPL License" folder as gpl.txt.

#import "GestureVisualizer.h"


@implementation GestureVisualizer

- (void)drawHistory:(unsigned)axis fromIndex:(unsigned)index inContext:(CGContextRef)context withBounds:(CGRect)bounds
{
    UIFont *font = [UIFont systemFontOfSize:12];
    unsigned i;
    float value, temp;
    
    // Draw the background
    CGContextSetGrayFillColor(context, 0.6, 1.0);
    CGContextFillRect(context, bounds);
    
    // Draw the intermediate lines
    CGContextSetGrayStrokeColor(context, 0.5, 1.0);
    CGContextBeginPath(context);
    for (value = -kMaxAcceleration + 1.0; value <= kMaxAcceleration - 1.0; value += 1.0)
    {
        if (value == 0.0) 
        {
            continue;
        }
        
        temp = roundf(bounds.origin.y + bounds.size.height / 2 + value / (2 * kMaxAcceleration) * bounds.size.height);
        CGContextMoveToPoint(context, bounds.origin.x, temp);
        CGContextAddLineToPoint(context, bounds.origin.x + bounds.size.width, temp);
    }
    CGContextStrokePath(context);
    
    // Draw the center line
    CGContextSetGrayStrokeColor(context, 1.0, 1.0);
    CGContextBeginPath(context);
    temp = roundf(bounds.origin.y + bounds.size.height / 2);
    CGContextMoveToPoint(context, bounds.origin.x, temp);
    CGContextAddLineToPoint(context, bounds.origin.x + bounds.size.width, temp);
    CGContextStrokePath(context);
    
    // Draw the top & bottom lines
    CGContextSetGrayStrokeColor(context, 0.25, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, bounds.origin.x, bounds.origin.y);
    CGContextAddLineToPoint(context, bounds.origin.x + bounds.size.width, bounds.origin.y);
    CGContextMoveToPoint(context, bounds.origin.x, bounds.origin.y + bounds.size.height);
    CGContextAddLineToPoint(context, bounds.origin.x + bounds.size.width, bounds.origin.y + bounds.size.height);
    CGContextStrokePath(context);
    
    // Draw the history lines
    CGContextSetRGBStrokeColor(context, (axis == 0 ? 1.0 : 0.0), (axis == 1 ? 1.0 : 0.0), (axis == 2 ? 1.0 : 0.0), 1.0);
    CGContextBeginPath(context);
    for (i = 0; i < kHistorySize; ++i)
    {
        // NOTE: We need to draw upside-down as UIView referential has the Y axis going down
        value = history[(index + i) % kHistorySize][axis] / -kMaxAcceleration; 
        if (i > 0)
        {
            CGContextAddLineToPoint(context, bounds.origin.x + (float)i / (float)(kHistorySize - 1) * bounds.size.width, 
                                    bounds.origin.y + bounds.size.height / 2 + value * bounds.size.height / 2);
        } 
        else 
        {
            CGContextMoveToPoint(context, bounds.origin.x + (float)i / (float)(kHistorySize - 1) * bounds.size.width, 
                                 bounds.origin.y + bounds.size.height / 2 + value * bounds.size.height / 2);
        }
    }
	CGContextSetLineWidth(context, 2.0);
    CGContextStrokePath(context);
	CGContextSetLineWidth(context, 1.0);
    
    // Draw the labels
    CGContextSetGrayFillColor(context, 1.0, 1.0);
    CGContextSetAllowsAntialiasing(context, true);
    for (value = -kMaxAcceleration; value <= kMaxAcceleration - 1.0; value += 1.0) 
    {
        temp = roundf(bounds.origin.y + bounds.size.height / 2 + value / (2 * kMaxAcceleration) * bounds.size.height);
        // NOTE: We need to draw upside-down as UIView referential has the Y axis going down
        [[NSString stringWithFormat:@"%+.1f", -(value >= 0.0 ? value + 1.0 : value)] 
         drawAtPoint:CGPointMake(bounds.origin.x + 4, temp + (value >= 0.0 ? 3 : 0)) withFont:font]; 
    }
    temp = roundf(bounds.origin.y + bounds.size.height / 2);
    CGPoint sPoint = CGPointMake(bounds.origin.x + bounds.size.width - 40, temp - 16);
    [[NSString stringWithFormat:@"%c Axis", 'X' + axis] drawAtPoint:sPoint withFont:font];
    CGContextSetAllowsAntialiasing(context, false);
}

- (void)createGestureView
{
    // show the gesture properties on the right upper half of screen
    CGSize size = [self bounds].size;
    
    // gesture name
    CGRect nameBounds = CGRectMake(size.width / 2 + 10, 0.0, 150.0, 30.0);
    nameLabel = [[UILabel alloc] initWithFrame:nameBounds];
    nameLabel.font = [UIFont systemFontOfSize: 14];
    nameLabel.textAlignment = UITextAlignmentLeft;
	nameLabel.textColor = [UIColor whiteColor];
	nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = [NSString stringWithFormat:@"Name: %@", [gesture name]];
	[self addSubview:nameLabel];
    
    // number of frames
    CGRect numFramesBounds = CGRectMake(size.width / 2 + 10, 40.0, 150.0, 30.0);
    numFramesLabel = [[UILabel alloc] initWithFrame:numFramesBounds];
    numFramesLabel.font = [UIFont systemFontOfSize: 14];
    numFramesLabel.textAlignment = UITextAlignmentLeft;
	numFramesLabel.textColor = [UIColor whiteColor];
	numFramesLabel.backgroundColor = [UIColor clearColor];
    numFramesLabel.text = [NSString stringWithFormat:@"Number of Frames: %u", [gesture numFrames]];
	[self addSubview:numFramesLabel];
    
    // currently matched frame
    CGRect frameBounds = CGRectMake(size.width / 2 + 10, 80.0, 150.0, 30.0);
    frameLabel = [[UILabel alloc] initWithFrame:frameBounds];
    frameLabel.font = [UIFont systemFontOfSize: 14];
    frameLabel.textAlignment = UITextAlignmentLeft;
	frameLabel.textColor = [UIColor whiteColor];
	frameLabel.backgroundColor = [UIColor clearColor];
    frameLabel.text = [NSString stringWithFormat:@"Current Frame: %u", [gesture currentlyMatchedFrame]];
	[self addSubview:frameLabel];
    
    // did the gesture occur?
    CGRect occurBounds = CGRectMake(size.width / 2 + 10, 120.0, 150.0, 30.0);
    occurredLabel = [[UILabel alloc] initWithFrame:occurBounds];
    occurredLabel.font = [UIFont systemFontOfSize: 14];
    occurredLabel.textAlignment = UITextAlignmentLeft;
	occurredLabel.textColor = [UIColor whiteColor];
	occurredLabel.backgroundColor = [UIColor clearColor];
    if([gesture didOccur])
    {
        occurredLabel.text = [NSString stringWithFormat:@"Occured: YES, %u", numOccurrences];
    }
    else
    {
        occurredLabel.text = [NSString stringWithFormat:@"Occured: NO"];
    }
	[self addSubview:occurredLabel];
    
    // last occurrence
    CGRect loBounds = CGRectMake(size.width / 2 + 10, 145.0, 150.0, 30.0);
    loLabel = [[UILabel alloc] initWithFrame:loBounds];
    loLabel.font = [UIFont systemFontOfSize: 14];
    loLabel.textAlignment = UITextAlignmentLeft;
	loLabel.textColor = [UIColor whiteColor];
	loLabel.backgroundColor = [UIColor clearColor];
    loLabel.numberOfLines = 0;
    loLabel.text = [NSString stringWithFormat:@"Last Occurred: %u", [gesture lastOccurrence]];
	[self addSubview:loLabel];
}

- (void)drawRect:(CGRect)clip
{
    CGSize size = [self bounds].size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    unsigned i;
    unsigned index = nextIndex;
    
    // Draw the X, Y & Z graphs with anti-aliasing turned off on left half of screen
    CGContextSetAllowsAntialiasing(context, false);
    CGFloat hOver3 = size.height / 3;
    for (i = 0; i < 3; ++i)
    {
        CGRect hBounds = CGRectMake(0, (float)i * hOver3, size.width / 2, hOver3);
        [self drawHistory:i fromIndex:index inContext:context withBounds:hBounds];
    }
    CGContextSetAllowsAntialiasing(context, true);
}

- (void)setGesture:(Gesture *)g withTracker:(GestureTracker *)t
{
    if(gesture != g)
    {
        [gesture release];
        
        gesture = g;
        numOccurrences = 0;
    }
    
    if(tracker != t)
    {
        [tracker release];
        
        tracker = t;
    }
    
    if(nameLabel != nil)
    {
        nameLabel.text = [NSString stringWithFormat:@"Name: %@", [gesture name]];
        numFramesLabel.text = [NSString stringWithFormat:@"Number of Frames: %u", [gesture numFrames]];
    }
    
    [gesture retain];
    [tracker retain];
}

- (void)enableDelegation
{
    [tracker addDelegate:self];
}

- (void)disableDelegation
{
    [tracker removeDelegate:self];
}

- (void)gestureOccurred:(Gesture *)g atTime:(NSTimeInterval)time
{
    if(g == gesture)
    {
        numOccurrences++;
        occurredLabel.text = [NSString stringWithFormat:@"Occured: YES, %u", numOccurrences];
        loLabel.text = [NSString stringWithFormat:@"Last Occurred: %u", [gesture lastOccurrence]];
        frameLabel.text = [NSString stringWithFormat:@"Current Frame: %u", [gesture currentlyMatchedFrame]];
    }
}

- (void)gesturePartiallyOccurred:(Gesture *)g withCompletedFrames:(NSUInteger)frames atTime:(NSTimeInterval)time
{
    if(g == gesture)
    {
        frameLabel.text = [NSString stringWithFormat:@"Current Frame: %u", [gesture currentlyMatchedFrame]];
    }
}

- (void)updatedAccelerationValues
{
    if(tracker != nil)
    {
        NSArray *accel = [tracker getAccelerationValues];
        history[nextIndex][0] = [[accel objectAtIndex:0] doubleValue];
        history[nextIndex][1] = [[accel objectAtIndex:1] doubleValue];
        history[nextIndex][2] = [[accel objectAtIndex:2] doubleValue];
        
        nextIndex = (nextIndex + 1) % kHistorySize;
        
        [self setNeedsDisplay];
    }
}

- (void)dealloc
{
    [gesture release];
    [tracker release];
    
    [nameLabel release];
    
    [super dealloc];
}

@end


@implementation GestureVisualizerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
		// Initialization code
        gv = [[GestureVisualizer alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        
        self.title = @"Gesture Visualizer";
        
        // create gesture properties frame
        [gv createGestureView];
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)loadView
{ 
    self.view = gv;
}

- (void)viewWillAppear:(BOOL)animated
{
    // enable delegation with the set gesture tracker
    [gv enableDelegation];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // no need to keep delegating now that we are going away
    [gv disableDelegation];
    
    [super viewWillDisappear:animated];
}

- (void)setGesture:(Gesture *)g withTracker:(GestureTracker *)t
{
    [gv setGesture:g withTracker:t];
}

- (void)selectedRowWithParameters:(NSArray *)params
{
    // parameters contain gesture and tracker to set, in that order
    if([params count] != 2)
    {
        return;
    }
    
    [self setGesture:[params objectAtIndex:0] withTracker:[params objectAtIndex:1]];
}

- (void)dealloc
{
    [gv release];
    
    [super dealloc];
}

@end

