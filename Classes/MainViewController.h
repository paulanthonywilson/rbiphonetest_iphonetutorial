#import <UIKit/UIKit.h>

#import "TwitterAccount.h";


@interface MainViewController : UIViewController<UITextViewDelegate, TweetObserver> {
@private
    IBOutlet UITextView *tweetTextView;
    TwitterAccount *twitterAccount;
}

+(id) mainViewControllerWithTwitterAccount:(TwitterAccount*)twitterAccount;

-(void)send:(id)sender;

@property(nonatomic,retain)  UITextView *tweetTextView;

@end
