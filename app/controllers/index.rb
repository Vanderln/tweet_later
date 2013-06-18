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
  # puts @access_token.inspect
  screen_name = @access_token.params[:screen_name]
  twitter_user_id = @access_token.params[:user_id]
  oauth_token = @access_token.params[:oauth_token]
  oauth_secret = @access_token.params[:oauth_token_secret]
  @user = User.create(:screen_name => screen_name, :twitter_user_id => twitter_user_id,
                      :oauth_token => oauth_token, :oauth_secret => oauth_secret )
  # at this point in the code is where you'll need to create your user account and store the access token
  puts @user.inspect
  erb :index
end
