#import <UIKit/UIKit.h>

@class MainViewController;
@class FlipsideViewController;
@class TwitterAccount;

@interface RootViewController : UIViewController {

	UIButton *infoButton;
	MainViewController *mainViewController;
	FlipsideViewController *flipsideViewController;
	UINavigationBar *flipsideNavigationBar;
@private
	TwitterAccount *twitterAccount;
}

@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) UINavigationBar *flipsideNavigationBar;
@property (nonatomic, retain) FlipsideViewController *flipsideViewController;

- (IBAction)toggleView;

@end
