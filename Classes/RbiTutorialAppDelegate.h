//
//  RbiTutorialAppDelegate.h
//  RbiTutorial
//
//  Created by Paul Wilson on 06/12/2008.
//  Copyright Mere Complexities Limited 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface RbiTutorialAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

