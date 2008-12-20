//
//  iMovesAppDelegate.m
//  iMoves
//
//  Created by Brian Wilke on 11/18/08.
//

// Copyright 2008 Brian Wilke.  All rights reserved.

// This program is distributed under the terms of the
// GNU General Public License.  A copy of this license
// is availabe in the "GPL License" folder as gpl.txt.

#import "iMovesAppDelegate.h"

#import "NavigationView.h"
#import "MovesView.h"
#import "GestureVisualizer.h"

@implementation iMovesAppDelegate

@synthesize window;

- (void)createViews
{
    // navigation gestures
    NavigationGestures *navigationGestures = [[NavigationGestures alloc] init];
    
    // navigation views
    NavigationView* navigationView = [[[NavigationView alloc] initWithStyle:UITableViewStylePlain] autorelease];
    NavigationView* loadGame = [[[NavigationView alloc] initWithStyle:UITableViewStylePlain] autorelease];
    NavigationView* gestureCreator = [[[NavigationView alloc] initWithStyle:UITableViewStylePlain] autorelease];
    NavigationView* gvMenu = [[[NavigationView alloc] initWithStyle:UITableViewStylePlain] autorelease];
    
    // game view
    MovesView* movesView = [[[MovesView alloc] init] autorelease];
    
    // gesture visualizer
    GestureVisualizerController *gestureVisualizer = [[[GestureVisualizerController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    // menu audio names
    NSString* new_game_file_str = [[NSBundle mainBundle] pathForResource:@"NewGame" ofType:@"caf"];
    NSString* load_game_file_str = [[NSBundle mainBundle] pathForResource:@"LoadGame" ofType:@"caf"];
    NSString* gesture_creator_file_str = [[NSBundle mainBundle] pathForResource:@"GestureCreator" ofType:@"caf"];
    NSString* gesture_visualizer_file_str = [[NSBundle mainBundle] pathForResource:@"GestureVisualizer" ofType:@"caf"];
    
    NSString* todo_file_str = [[NSBundle mainBundle] pathForResource:@"TODO" ofType:@"caf"];
    
    NSString* create_gesture_file_str = [[NSBundle mainBundle] pathForResource:@"CreateGesture" ofType:@"caf"];
    NSString* play_gesture_file_str = [[NSBundle mainBundle] pathForResource:@"PlayGesture" ofType:@"caf"];
    NSString* load_gesture_file_str = [[NSBundle mainBundle] pathForResource:@"LoadGesture" ofType:@"caf"];
    
    NSString* scroll_down_file_str = [[NSBundle mainBundle] pathForResource:@"ScrollDown" ofType:@"caf"];
    NSString* go_forward_file_str = [[NSBundle mainBundle] pathForResource:@"GoForward" ofType:@"caf"];
    NSString* go_backward_file_str = [[NSBundle mainBundle] pathForResource:@"GoBackward" ofType:@"caf"];
    
    // main page
    [navigationView addRowWithName:@"newgame" andDisplayText:@"New Game" atPosition:[[NSNumber alloc] initWithUnsignedInt:0] 
                         inSection:[[NSNumber alloc] initWithUnsignedInt:0] withViewController:movesView thatNeedsParameters:nil];
    [navigationView playSound:new_game_file_str whenSelectingRowWithName:@"newgame"];
    
    [navigationView addRowWithName:@"loadgame" andDisplayText:@"Load Game" atPosition:[[NSNumber alloc] initWithUnsignedInt:1] 
                         inSection:[[NSNumber alloc] initWithUnsignedInt:0] withViewController:loadGame thatNeedsParameters:nil];
    [navigationView playSound:load_game_file_str whenSelectingRowWithName:@"loadgame"];
    
    [navigationView addRowWithName:@"gesturecreator" andDisplayText:@"Gesture Creator" atPosition:[[NSNumber alloc] initWithUnsignedInt:2] 
                         inSection:[[NSNumber alloc] initWithUnsignedInt:0] withViewController:gestureCreator thatNeedsParameters:nil];
    [navigationView playSound:gesture_creator_file_str whenSelectingRowWithName:@"gesturecreator"];
    
    [navigationView addRowWithName:@"gesturevisualizer" andDisplayText:@"Gesture Visualizer" atPosition:[[NSNumber alloc] initWithUnsignedInt:3]
                         inSection:[[NSNumber alloc] initWithUnsignedInt:0] withViewController:gvMenu thatNeedsParameters:nil];
    [navigationView playSound:gesture_visualizer_file_str whenSelectingRowWithName:@"gesturevisualizer"];
    
    navigationView->navGestures = navigationGestures;
    navigationView.title = @"iMoves";
    
    // load game
    // TODO: saving/loading mechanism
    [loadGame addRowWithName:@"todo" andDisplayText:@"TODO" atPosition:[[NSNumber alloc] initWithUnsignedInt:0] 
                   inSection:[[NSNumber alloc] initWithUnsignedInt:0] withViewController:nil thatNeedsParameters:nil];
    [loadGame playSound:todo_file_str whenSelectingRowWithName:@"todo"];
    
    loadGame->navGestures = navigationGestures;
    loadGame.title = @"Load Game";
    
    // gesture creator
    [gestureCreator addRowWithName:@"creategesture" andDisplayText:@"Create Gesture" atPosition:[[NSNumber alloc] initWithUnsignedInt:0] 
                         inSection:[[NSNumber alloc] initWithUnsignedInt:0] withViewController:nil thatNeedsParameters:nil];
    [gestureCreator playSound:create_gesture_file_str whenSelectingRowWithName:@"creategesture"];
    
    [gestureCreator addRowWithName:@"playgesture" andDisplayText:@"Play Gesture" atPosition:[[NSNumber alloc] initWithUnsignedInt:1] 
                         inSection:[[NSNumber alloc] initWithUnsignedInt:0] withViewController:nil thatNeedsParameters:nil];
    [gestureCreator playSound:play_gesture_file_str whenSelectingRowWithName:@"playgesture"];
    
    [gestureCreator addRowWithName:@"loadgestures" andDisplayText:@"Load Gestures" atPosition:[[NSNumber alloc] initWithUnsignedInt:2] 
                         inSection:[[NSNumber alloc] initWithUnsignedInt:0] withViewController:nil thatNeedsParameters:nil];
    [gestureCreator playSound:load_gesture_file_str whenSelectingRowWithName:@"loadgestures"];
    
    // TODO: gesture creator mechanism
    
    gestureCreator->navGestures = navigationGestures;
    gestureCreator.title = @"Gesture Creator";
    
    // gesture visualizer menu (right now only does NavigationGestures
    // TODO: generalize for any gesture tracker with gestures
    NSArray* sd_params = [[NSArray alloc] initWithObjects:[navigationGestures scroll_down], [navigationGestures tracker], nil];
    NSArray* gf_params = [[NSArray alloc] initWithObjects:[navigationGestures go_forward], [navigationGestures tracker], nil];
    NSArray* gb_params = [[NSArray alloc] initWithObjects:[navigationGestures go_backward], [navigationGestures tracker], nil];
    
    [gvMenu addRowWithName:@"scrolldown" andDisplayText:@"Scroll Down" atPosition:[[NSNumber alloc] initWithUnsignedInt:0] 
                 inSection:[[NSNumber alloc] initWithUnsignedInt:0] withViewController:gestureVisualizer thatNeedsParameters:sd_params];
    [gvMenu playSound:scroll_down_file_str whenSelectingRowWithName:@"scrolldown"];
    
    [gvMenu addRowWithName:@"goforward" andDisplayText:@"Go Forward" atPosition:[[NSNumber alloc] initWithUnsignedInt:1] 
                 inSection:[[NSNumber alloc] initWithUnsignedInt:0] withViewController:gestureVisualizer thatNeedsParameters:gf_params];
    [gvMenu playSound:go_forward_file_str whenSelectingRowWithName:@"goforward"];
    
    [gvMenu addRowWithName:@"gobackward" andDisplayText:@"Go Backward" atPosition:[[NSNumber alloc] initWithUnsignedInt:2] 
                 inSection:[[NSNumber alloc] initWithUnsignedInt:0] withViewController:gestureVisualizer thatNeedsParameters:gb_params];
    [gvMenu playSound:go_backward_file_str whenSelectingRowWithName:@"gobackward"];
    
    gvMenu->navGestures = navigationGestures;
    [gvMenu setDelegate:gestureVisualizer];
    gvMenu.title = @"Gesture Visualizer";
    
    // initialize navigation controller
    navigationController = [[UINavigationController alloc] initWithRootViewController:navigationView];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // initialize views
    [self createViews];

    // initialize window
    [window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [navigationController release];
	[window release];
	[super dealloc];
}


@end
