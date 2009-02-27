//
//  FlipsideViewController.h
//  RbiTutorial
//
//  Created by Paul Wilson on 06/12/2008.
//  Copyright Mere Complexities Limited 2008. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TwitterAccount; 


@interface FlipsideViewController : UIViewController {
@private 
	TwitterAccount *twitterAccount;
	IBOutlet UITextField *usernameField;
	IBOutlet UITextField *passwordField;
	
}


+(id) flipSideViewControllerWithTwitterAccount:(TwitterAccount*) twitterAccount;
@end
