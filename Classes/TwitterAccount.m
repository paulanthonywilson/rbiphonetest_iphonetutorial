#import "TwitterAccount.h"

@interface TweetDelegate : NSObject{
	NSString *username;
	NSString *password;
	id<TweetObserver> tweetObserver;
}
@property(nonatomic, retain) NSString* username;
@property(nonatomic, retain) NSString* password;
@property(nonatomic, retain) id<TweetObserver> tweetObserver;

@end

@implementation TweetDelegate
@synthesize username;
@synthesize password;
@synthesize tweetObserver;

+(id)tweetDelegateWithUsername:(NSString*)username password:(NSString*)password andTweetObserver:(id<TweetObserver>) observer{
	TweetDelegate *result = [[TweetDelegate alloc] autorelease];
	result.username = username;
	result.password = password;
	result.tweetObserver = observer;
	return result;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge previousFailureCount] == 0){
		NSURLCredential *credential = [[NSURLCredential alloc] 
			initWithUser:self.username 
			password:self.password
			persistence:NSURLCredentialPersistenceForSession]; 

		[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
		[credential release];
	}
	else{
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}	
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
	[self.tweetObserver tweetSucceeded];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	if ([error code] == NSURLErrorUserCancelledAuthentication){
		[self.tweetObserver tweetFailedAuthentication];
	}else{	
		[self.tweetObserver tweetFailedWithError:error];
	}
}

@end

@implementation TwitterAccount
@synthesize username;
@synthesize password;

-(NSString*) accountPlistPath{
	NSString *userDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [userDir stringByAppendingPathComponent:@"account.plist"];
}

-(void) save{
	NSString *path = [self accountPlistPath];
	NSDictionary *accountDetails = [NSDictionary dictionaryWithObjectsAndKeys:self.username, 
		@"username", self.password, @"password", nil];
	BOOL written = [accountDetails writeToFile:path atomically:YES];
	NSLog(@"written: %d", written);

}

-(void) load{
	NSDictionary *accountDetails = [[NSDictionary alloc] initWithContentsOfFile:[self accountPlistPath]];	
	self.username = [accountDetails objectForKey:@"username"];
	self.password = [accountDetails objectForKey:@"password"];
	[accountDetails release];
}

-(void) tweet:(NSString*)message andNotifyObserver:(id<TweetObserver>) observer{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://twitter.com/statuses/update.xml"]];
	request.HTTPMethod = @"POST";
	request.HTTPBody = [[NSString stringWithFormat:@"status=%@",message] dataUsingEncoding:NSUTF8StringEncoding];
	[NSURLConnection connectionWithRequest:request delegate:
	[TweetDelegate tweetDelegateWithUsername:self.username password:self.password andTweetObserver:observer]];
}



+(id) loadFromPlist{
	TwitterAccount *result = [[TwitterAccount alloc] autorelease];
	[result load];
	return result;
}


@end

// This initialization function gets called when we import the Ruby module.
// It doesn't need to do anything because the RubyCocoa bridge will do
// all the initialization work.
// The rbiphonetest test framework automatically generates bundles for 
// each objective-c class containing the following line. These
// can be used by your tests.
void Init_TwitterAccount() { }