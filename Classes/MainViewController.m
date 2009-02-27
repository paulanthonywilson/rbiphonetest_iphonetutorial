//
//  MainViewController.m
//  RbiTutorial
//
//  Created by Paul Wilson on 06/12/2008.
//  Copyright Mere Complexities Limited 2008. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "TwitterAccount.h"


@interface MainViewController()
@property(nonatomic, retain) TwitterAccount *twitterAccount;
@end

@implementation MainViewController

@synthesize tweetTextView;
@synthesize twitterAccount;

-(void)send:(id)sender{
    [self.twitterAccount tweet:self.tweetTextView.text andNotifyObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

+(id) mainViewControllerWithTwitterAccount:(TwitterAccount*)twitterAccount{
	MainViewController *result = [[[MainViewController alloc] initWithNibName:@"MainView" bundle: nil] autorelease];
	result.twitterAccount = twitterAccount;
	return result;
}

-(void)tweetSucceeded{
    self.tweetTextView.text=@"";
}

-(void)tweetFailedWithError:(NSError*) error{
    UIAlertView *errorAlert = [[UIAlertView alloc] 
                               initWithTitle: [error localizedDescription] 
                               message: [error localizedFailureReason] 
                               delegate:nil 
                               cancelButtonTitle:@"OK" 
                               otherButtonTitles:nil]; 
    [errorAlert show]; 
    [errorAlert release];
    
}
-(void)tweetFailedAuthentication{
        UIAlertView *errorAlert = [[UIAlertView alloc] 
                                   initWithTitle: @"Failed authentication"
                                   message: @"Please check your username and password"
                                   delegate:nil 
                                   cancelButtonTitle:@"OK" 
                                   otherButtonTitles:nil]; 
        [errorAlert show]; 
        [errorAlert release];
        
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
