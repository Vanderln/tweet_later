class User < ActiveRecord::Base
  has_many :tweets

  def tweet(status)
    tweet = tweets.create!(:status => status)
    TweetWorker.perform_async(tweet.id)
  end

  def tweet_later(interval, status)
    tweet = tweets.create!(:status => status)
    TweetWorker.perform_in(interval.to_i.minutes, tweet.id)
  end

  def twitter_client
    @twitter_client ||= Twitter::Client.new(:oauth_token => oauth_token, :oauth_token_secret => oauth_secret)
  end
end
