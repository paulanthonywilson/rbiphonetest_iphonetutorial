require File.dirname(__FILE__) + '/test_helper'
require 'tempfile'
require 'fileutils'

require "TwitterAccount.bundle"
OSX::ns_import :TwitterAccount

class OSX::TwitterAccount
  objc_alias_method :original_accountPlistPath, :accountPlistPath
  def accountPlistPath
    TestTwitterAccount.trick_account_plist_path
  end    
end


class StubAuthenticationChallenge < OSX::NSURLAuthenticationChallenge 
  attr_reader :sender
  attr_accessor :previousFailureCount

  class StubSender 
    attr_reader :credential, :challenge, :cancelled_challenge
    def useCredential_forAuthenticationChallenge credential, challenge
      @credential = credential.retain.autorelease if credential
      @challenge = challenge
    end

    def cancelAuthenticationChallenge challenge
      @cancelled_challenge = challenge
    end
  end


  def initialize
    @previousFailureCount = 0
    @sender = StubSender.new
  end


  def credential_used
    @sender.credential
  end

  def challenge_used_with_credential
    @sender.challenge
  end

  def cancelled?
    @sender.cancelled_challenge
  end
end

class StubTweetObserver
  attr_reader :tweet_succeeded, :tweet_error, :tweet_failed_authentication
  def tweetSucceeded
    @tweet_succeeded = true
  end

  def tweetFailedWithError error
    @tweet_error = error
  end

  def tweetFailedAuthentication
    @tweet_failed_authentication = true
  end
end


class OSX::NSURLConnection
  class << self
    attr_reader :last_request_url, :last_request_method, :last_request_body, :last_delegate;
    define_method 'connectionWithRequest:delegate:' do |request, delegate|
      @last_request_url = request.URL.absoluteString
      @last_request_method = request.HTTPMethod
      @last_request_body = request.HTTPBody
      @last_delegate = delegate
    end
  end
end


class TestTwitterAccount < Test::Unit::TestCase
  def self.trick_account_plist_path
    @@account_plist_path||= Tempfile.new("accountPlistPath").path
  end 


  def setup
    FileUtils.rm_f TestTwitterAccount.trick_account_plist_path 
    @tweet_observer = StubTweetObserver.new
    @testee = OSX::TwitterAccount.loadFromPlist
  end

  def test_account_plist_is_saved_to_user_document_directory
    assert_equal File.expand_path("~/Documents/account.plist"), @testee.original_accountPlistPath
  end

  def test_twitter_account_has_username_and_password
    @testee.username = 'marvin'
    @testee.password = 'tellnot'
    assert_equal "marvin", @testee.username
    assert_equal "tellnot", @testee.password
  end

  def test_account_details_may_be_saved_and_reloaded
    @testee.username = 'victoria'
    @testee.password = 'secret'
    @testee.save

    reloaded = OSX::TwitterAccount.alloc.init
    reloaded.load

    assert_equal "victoria", reloaded.username
    assert_equal "secret", reloaded.password       
  end

  def test_username_and_password_are_initially_nil_if_not_previously_saved
    assert_equal nil, @testee.username
    assert_equal nil, @testee.password
  end

  def test_tweets_are_post_sent_to_the_correct_twitter_api_with_the_message_in_the_status_parameter
    @testee.tweet_andNotifyObserver "hello matey", @tweet_observer
    assert_equal "http://twitter.com/statuses/update.xml", OSX::NSURLConnection.last_request_url
    assert_equal "POST", OSX::NSURLConnection.last_request_method
    assert_last_request_body "status=hello matey"
  end

  def test_username_and_password_used_in_response_to_authentication_challenge
    @testee.username = 'rita'
    @testee.password = 'mysecret'
    @testee.tweet_andNotifyObserver "hi", @tweet_observer

    challenge = StubAuthenticationChallenge.alloc
    assert  OSX::NSURLConnection.last_delegate
    OSX::NSURLConnection.last_delegate.connection_didReceiveAuthenticationChallenge nil, challenge

    assert_equal challenge, challenge.challenge_used_with_credential
    assert challenge.credential_used
    assert_equal "rita", challenge.credential_used.user
    assert_equal "mysecret", challenge.credential_used.password

  end

  def test_only_attempts_to_authenticate_once_against_an_authentication_challenge 
    challenge = StubAuthenticationChallenge.alloc
    challenge.previousFailureCount = 1

    @testee.username = 'rita'
    @testee.password = 'mysecret'
    @testee.tweet_andNotifyObserver "yo", @tweet_observer
    OSX::NSURLConnection.last_delegate.connection_didReceiveAuthenticationChallenge nil, challenge

    assert challenge.credential_used.nil?
    assert challenge.cancelled?
  end

  def test_should_be_notified_of_a_successful_tweet
    @testee.tweet_andNotifyObserver "hey", @tweet_observer
    OSX::NSURLConnection.last_delegate.connectionDidFinishLoading nil
    assert @tweet_observer.tweet_succeeded
  end

  def test_listener_notified_of_failure
    error = OSX::NSError.alloc

    @testee.tweet_andNotifyObserver "oi!", @tweet_observer
    OSX::NSURLConnection.last_delegate.connection_didFailWithError nil, error

    assert_equal error, @tweet_observer.tweet_error
    assert !@tweet_observer.tweet_succeeded  
  end
  
  def test_user_notified_of_authentication_failure
    error = OSX::NSError.errorWithDomain_code_userInfo("NSURLErrorDomain", OSX::NSURLErrorUserCancelledAuthentication, nil)
    @testee.tweet_andNotifyObserver "hi!", @tweet_observer

    OSX::NSURLConnection.last_delegate.connection_didFailWithError nil, error
    assert @tweet_observer.tweet_failed_authentication
    assert !@tweet_observer.tweet_error
    assert !@tweet_observer.tweet_succeeded    
  end

private
  def assert_last_request_body(expected)
    assert_equal expected, OSX::NSURLConnection.last_request_body.bytes.bytestr(expected.size)
  end

end