get '/' do
  erb :index
end

get '/sign_in' do

  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  screen_name = @access_token.params[:screen_name]
  twitter_user_id = @access_token.params[:user_id]
  oauth_token = @access_token.params[:oauth_token]
  oauth_secret = @access_token.params[:oauth_token_secret]

  @user = User.find_or_create_by_screen_name(screen_name)
  @user.twitter_user_id = twitter_user_id
  @user.oauth_token = oauth_token
  @user.oauth_secret = oauth_secret 
  @user.save

  session[:user_id] = @user.id
  erb :tweet_something
end

get '/tweet' do
  erb :tweet
end

post '/tweet' do
  tweet = params[:tweet]
  @job_id = current_user.tweet(tweet)
  content_type :json
  {"jobID" => @job_id }.to_json
end

post '/tweet_later' do
 p ">>>>>>>>>>>>>>>>>>>>>>>>"
  p params[:minutes].to_i.inspect
  tweet = params[:tweet]
  if params[:minutes].to_i
    interval = params[:minutes].to_i
  else
    interval = 0
  end
  @job_id = current_user.tweet_later(interval.minutes.from_now, tweet)
  content_type :json
  {"jobID" => @job_id }.to_json
end

get '/logout' do
  session.clear
  redirect '/'
end

get '/status/:job_id' do
  complete = job_is_complete(params[:job_id])
  complete.to_s

end
