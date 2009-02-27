#import "TwitterAccount.h"
#import "FlipsideViewController.h"

@interface FlipsideViewController()
@property(nonatomic, retain) TwitterAccount *twitterAccount;
@property(nonatomic, retain) IBOutlet UITextField *usernameField;
@property(nonatomic, retain) IBOutlet UITextField *passwordField;

@end

@implementation FlipsideViewController

@synthesize twitterAccount;
@synthesize usernameField;
@synthesize passwordField;


+(id) flipSideViewControllerWithTwitterAccount:(TwitterAccount*) twitterAccount{
	FlipsideViewController *result = [[[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil] autorelease];
	result.twitterAccount = twitterAccount;
	return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
    self.usernameField.text = self.twitterAccount.username;
    self.passwordField.text = self.twitterAccount.password;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
	self.twitterAccount.username = self.usernameField.text;
	self.twitterAccount.password = self.passwordField.text;
	[self.twitterAccount save];
}

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
