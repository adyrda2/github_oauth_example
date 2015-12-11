enable :sessions

get '/' do
  erb :index
end

get '/sign_in' do
  @consumer = OAuth::Consumer.new(ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET'], :site => "")

  @request_token = @consumer.get_request_token(:oauth_callback => "http://localhost:9393/auth")

  session[:request_token] = @request_token

  redirect @request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  @request_token = session[:request_token]

  @access_token = @request_token.get_access_token(:oauth_verifer => params[:oauth_verifer])

  erb: :index
end
