#import <Foundation/Foundation.h>

@protocol TweetObserver
-(void)tweetSucceeded;
-(void)tweetFailedWithError:(NSError*) error;
-(void)tweetFailedAuthentication;
@end

@interface TwitterAccount : NSObject {
@private
	NSString *username;
	NSString *password;
}
-(void) save;
-(void) tweet:(NSString*)message andNotifyObserver:(id<TweetObserver>) observer;
+(id) loadFromPlist;
@property(retain, nonatomic) NSString *username;
@property(retain, nonatomic) NSString *password;
@end
