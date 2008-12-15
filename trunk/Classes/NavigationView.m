//
//  NavigationView.m
//  iMoves
//
//  Created by Brian Wilke on 11/18/08.
//  Copyright 2008 Fluke Networks. All rights reserved.
//

#import "NavigationView.h"

#import <AudioToolbox/AudioToolbox.h>


@implementation NavigationView

#pragma mark Inherited methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self)
    {
        // Initialize list and rows
        navList = [[NSMutableSet alloc] init];
        sections = 1;
        rows = [[NSMutableArray alloc] init];
        
        NSNumber *first_sect = [[NSNumber alloc] initWithUnsignedInt:0];
        [rows addObject:first_sect];
        [first_sect release];
        
        curr_path = [NSIndexPath indexPathForRow:0 inSection:0];
        
        delegate = nil;
        
        using_sound_id = NO;
        soundFileURL = nil;
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

#pragma mark Class methods

+ (NSMutableDictionary *)createRowWithName:(NSString *)name andDisplayText:(NSString *)displayText atPosition:(NSNumber *)rowNum inSection:(NSNumber *)sectionNum withViewController:(UIViewController *)viewController
{
    NSMutableDictionary *newRow = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   name, @"name", displayText, @"displayText", rowNum, @"row", 
                                   sectionNum, @"section", viewController, @"viewController",
                                   nil, @"parameters", nil, @"sound", nil];
    return newRow;
}

# pragma mark Row operations

- (void)addRowWithName:(NSString *)name andDisplayText:(NSString *)displayText atPosition:(NSNumber *)rowNum inSection:(NSNumber *)sectionNum withViewController:(UIViewController *)viewController thatNeedsParameters:(NSArray *)params
{
    // make sure the new row is valid
    if([sectionNum unsignedIntValue] >= sections)
    {
        // cannot add new sections
        return;
    }
    else if([rowNum unsignedIntValue] != [[rows objectAtIndex:[sectionNum unsignedIntValue]] unsignedIntValue])
    {
        // must add new rows sequentially
        // i.e., if we have 3 rows, can add row '4,' but cannot add row '5'
        return;
    }
    
    NSMutableDictionary *newRow = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   name, @"name", displayText, @"displayText", rowNum, @"row", 
                                   sectionNum, @"section", viewController, @"viewController",
                                   params, @"parameters", nil, @"sound", nil];
    [navList addObject:newRow];
    [newRow release];
    
    NSNumber *inc = [[NSNumber alloc] initWithUnsignedInt:([[rows objectAtIndex:[sectionNum unsignedIntValue]] unsignedIntValue] + 1)];
    [rows replaceObjectAtIndex:[sectionNum unsignedIntValue] withObject:inc];
    [inc release];
}

- (void)playSound:(NSString *)soundFileName whenSelectingRowWithName:(NSString *)name
{
    for(NSMutableDictionary* dict in navList)
    {
        if(name == [dict objectForKey:@"name"])
        {
            [dict setObject:soundFileName forKey:@"sound"];
        }
    }
}

- (void)addRow:(NSDictionary *)newRow
{
    if(([newRow objectForKey:@"displayText"] == nil) ||
       ([newRow objectForKey:@"row"] == nil) ||
       ([newRow objectForKey:@"section"] == nil))
    {
        // impossible to use this row for the table
        return;
    }
    
    [self addRowWithName:[newRow objectForKey:@"name"] 
          andDisplayText:[newRow objectForKey:@"displayText"] 
          atPosition:[newRow objectForKey:@"row"]
          inSection:[newRow objectForKey:@"section"]
          withViewController:[newRow objectForKey:@"viewController"]
          thatNeedsParameters:[newRow objectForKey:@"parameters"]];
}

- (void)addRows:(NSSet *)newRows
{
    for(NSMutableDictionary* dict in newRows)
    {
        [self addRow:dict];
    }
}

- (void)deleteRowWithName:(NSString *)name inSection:(unsigned int)sectionNum
{
    for(NSMutableDictionary* dict in navList)
    {
        if((name == [dict objectForKey:@"name"]) &&
           (sectionNum == [[dict objectForKey:@"section"] unsignedIntValue]))
        {
            [navList removeObject:dict];
        }
    }
}

- (void)deleteRow:(NSDictionary *)delRow
{
    [self deleteRowWithName:[delRow objectForKey:@"name"] 
          inSection:[[delRow objectForKey:@"section"] unsignedIntValue]];
}

# pragma mark Section operations

- (void)addSection
{
    sections++;
    
    NSNumber* nr = [[NSNumber alloc] initWithUnsignedInt:0];
    [rows addObject:nr];
    [nr release];
}

- (void)addSectionWithRows:(NSSet *)newRows
{
    [self addSection];
    
    for(NSDictionary* dict in newRows)
    {
        if([[dict objectForKey:@"section"] unsignedIntValue] != sections)
        {
            continue;
        }
        
        [self addRow:dict];
    }
}


- (void)dealloc {
    [navList dealloc];
    [rows dealloc];
    
    if(using_sound_id)
    {
        AudioServicesDisposeSystemSoundID(sound_id);
        [soundFileURL release];
    }
    
	[super dealloc];
}

#pragma mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
    // become the delegate for the navigation gesture service
    if(navGestures != nil)
    {
        [navGestures setDelegate:self];
    }
    
    [super viewWillAppear:animated];
    
    // select the current path
    if((sections != 0) && ([[rows objectAtIndex:curr_path.section] unsignedIntValue] != 0))
    {
        [[self tableView] selectRowAtIndexPath:curr_path animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    
    // emit a vibration
    [self vibrate];
    
    // emit sound if it's got one
    for(NSMutableDictionary* dict in navList)
    {
        if(([[dict objectForKey:@"row"] unsignedIntValue] == curr_path.row) &&
           ([[dict objectForKey:@"section"] unsignedIntValue] == curr_path.section))
        {
            if([dict objectForKey:@"sound"] != nil)
            {
                if(!using_sound_id)
                {
                    NSString* file_str = [[NSString alloc] initWithString:[dict objectForKey:@"sound"]];
                    soundFileURL = [[NSURL fileURLWithPath:file_str isDirectory:NO] retain];

                    AudioServicesCreateSystemSoundID((CFURLRef)soundFileURL, &sound_id);
                    
                    [file_str release];
                }
                [self playRowSound];
                using_sound_id = YES;
            }
            
            break;
        }
    }
}

#pragma mark UITableView delegate methods

// decide what kind of accesory view (to the far right) we will use
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

// the table's selection has changed, switch to that item's UIViewController or the linked section
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    curr_path = indexPath;
    
    for(NSMutableDictionary* dict in navList)
    {
        if(([[dict objectForKey:@"row"] unsignedIntValue] == indexPath.row) &&
           ([[dict objectForKey:@"section"] unsignedIntValue] == indexPath.section))
        {
            // set up the sound if necessary
            if([dict objectForKey:@"sound"] != nil)
            {
                if(using_sound_id)
                {
                    AudioServicesDisposeSystemSoundID(sound_id);
                    [soundFileURL release];
                }
                
                NSString* file_str = [[NSString alloc] initWithString:[dict objectForKey:@"sound"]];
                soundFileURL = [[NSURL fileURLWithPath:file_str isDirectory:NO] retain];
                
                AudioServicesCreateSystemSoundID((CFURLRef)soundFileURL, &sound_id);
                
                [file_str release];
                using_sound_id = YES;
            }
            
            if([dict objectForKey:@"viewController"] != nil)
            {
                // unsubscribe to gesture delegation first
                [navGestures unsetDelegate];
                
                // give the new view controller the parameters in the row
                [delegate selectedRowWithParameters:[dict objectForKey:@"parameters"]];
                
                [[self navigationController] pushViewController:[dict objectForKey:@"viewController"] animated:YES];
            }
            
            break;
        }
    }
}

#pragma mark UITableView datasource methods

// tell our table how many sections or groups it will have
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return sections;
}

// tell our table how many rows it will have
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[rows objectAtIndex:section] intValue];
}

// tell our table what kind of cell to use and its title for the given row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"] autorelease];
    }
    
    for(NSMutableDictionary* dict in navList)
    {
        if(([[dict objectForKey:@"row"] unsignedIntValue] == indexPath.row) &&
           ([[dict objectForKey:@"section"] unsignedIntValue] == indexPath.section))
        {
            cell.text = [dict objectForKey:@"displayText"];
            
            break;
        }
    }
    
    return cell;
}
    
# pragma mark Delegation methods

- (void)setDelegate:(id <NavigationViewDelegate>)new_delegate
{
    delegate = new_delegate;
}

- (void)unsetDelegate
{
    delegate = nil;
}

- (void)selectedRowWithParameters:(NSArray *)params
{
    // navigation views shouldn't need parameters
}

# pragma mark Sound Routines

- (IBAction)playRowSound
{
    AudioServicesPlaySystemSound(sound_id);
}

- (IBAction)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

# pragma mark Navigate Gestures methods

- (void)scrollUp
{
    if(curr_path.row != 0)
    {
        curr_path = [NSIndexPath indexPathForRow:(curr_path.row - 1) inSection:curr_path.section];
    }
    else
    {
        curr_path = [NSIndexPath indexPathForRow:([[rows objectAtIndex:curr_path.section] intValue] - 1) inSection:curr_path.section];
    }
    
    [[self tableView] selectRowAtIndexPath:curr_path animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    // emit a vibration
    [self vibrate];
    
    // emit sound if it's got one
    for(NSMutableDictionary* dict in navList)
    {
        if(([[dict objectForKey:@"row"] unsignedIntValue] == curr_path.row) &&
           ([[dict objectForKey:@"section"] unsignedIntValue] == curr_path.section))
        {
            if([dict objectForKey:@"sound"] != nil)
            {
                if(using_sound_id)
                {
                    AudioServicesDisposeSystemSoundID(sound_id);
                    [soundFileURL release];
                }
                
                NSString* file_str = [[NSString alloc] initWithString:[dict objectForKey:@"sound"]];
                soundFileURL = [[NSURL fileURLWithPath:file_str isDirectory:NO] retain];
                
                AudioServicesCreateSystemSoundID((CFURLRef)soundFileURL, &sound_id);
                [self playRowSound];
                using_sound_id = YES;
                
                [file_str release];
            }
            
            break;
        }
    }
}

- (void)scrollDown
{
    if(curr_path.row != ([[rows objectAtIndex:curr_path.section] intValue] - 1))
    {
        curr_path = [NSIndexPath indexPathForRow:(curr_path.row + 1) inSection:curr_path.section];
    }
    else
    {
        curr_path = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [[self tableView] selectRowAtIndexPath:curr_path animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    // emit a vibration
    [self vibrate];
    
    // emit sound if it's got one
    for(NSMutableDictionary* dict in navList)
    {
        if(([[dict objectForKey:@"row"] unsignedIntValue] == curr_path.row) &&
           ([[dict objectForKey:@"section"] unsignedIntValue] == curr_path.section))
        {
            if([dict objectForKey:@"sound"] != nil)
            {
                if(using_sound_id)
                {
                    AudioServicesDisposeSystemSoundID(sound_id);
                    [soundFileURL release];
                }
                
                NSString* file_str = [[NSString alloc] initWithString:[dict objectForKey:@"sound"]];
                soundFileURL = [[NSURL fileURLWithPath:file_str isDirectory:NO] retain];
                
                AudioServicesCreateSystemSoundID((CFURLRef)soundFileURL, &sound_id);
                [self playRowSound];
                using_sound_id = YES;
                
                [file_str release];
            }
            
            break;
        }
    }
}

- (void)goForward
{
    // go forward in menu
    [self tableView:[self tableView] didSelectRowAtIndexPath:curr_path];
}

- (void)goBackward
{
    // pop self off of view controller
    [[self navigationController] popViewControllerAnimated:NO];
}

@end
