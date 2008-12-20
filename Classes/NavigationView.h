//
//  NavigationView.h
//  iMoves
//
//  Created by Brian Wilke on 11/18/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in gpl.txt.

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

#import "NavigationGestures.h"

@protocol NavigationViewDelegate

- (void)selectedRowWithParameters:(NSArray *)params;

@end

@interface NavigationView : UITableViewController <NavigationGestureDelegate, NavigationViewDelegate>
{
    NSMutableSet* navList;          // list containing the table data
    unsigned int sections;          // number of sections
    NSMutableArray* rows;           // number of rows per section
    NSIndexPath* curr_path;         // current table path we're investigating
    
    id delegate;                    // delegate for parameter passing
    
    BOOL using_sound_id;            // YES if we are using the sound id; NO otherwise
    NSURL* soundFileURL;            // url of sound file
    SystemSoundID sound_id;         // sound id for playing sounds
    
@public
    NavigationGestures* navGestures; // navigation gesture service provided by instantiator
}

+ (NSMutableDictionary *)createRowWithName:(NSString *)name andDisplayText:(NSString *)displayText atPosition:(NSNumber *)rowNum inSection:(NSNumber *)sectionNum withViewController:(UIViewController *)viewController;

- (void)addRowWithName:(NSString *)name andDisplayText:(NSString *)displayText atPosition:(NSNumber *)rowNum inSection:(NSNumber *)sectionNum withViewController:(UIViewController *)viewController thatNeedsParameters:(NSArray *)params;
- (void)playSound:(NSString *)soundFileName whenSelectingRowWithName:(NSString *)name;
- (void)addRow:(NSDictionary *)newRow;
- (void)addRows:(NSSet *)newRows;

- (void)deleteRowWithName:(NSString *)name inSection:(unsigned int)sectionNum;
- (void)deleteRow:(NSDictionary *)delRow;

- (void)addSection;
- (void)addSectionWithRows:(NSSet *)newRows;

- (void)setDelegate:(id <NavigationViewDelegate>)new_delegate;
- (void)unsetDelegate;

- (void)selectedRowWithParameters:(NSArray *)params;

- (IBAction)playRowSound;
- (IBAction)vibrate;

@end
