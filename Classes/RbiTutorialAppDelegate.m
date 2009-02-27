//
//  RbiTutorialAppDelegate.m
//  RbiTutorial
//
//  Created by Paul Wilson on 06/12/2008.
//  Copyright Mere Complexities Limited 2008. All rights reserved.
//

#import "RbiTutorialAppDelegate.h"
#import "RootViewController.h"

@implementation RbiTutorialAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [rootViewController release];
    [window release];
    [super dealloc];
}

@end
