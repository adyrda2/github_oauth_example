enable :sessions

get '/' do

  erb :index
end

get '/callback' do
  result = RestClient.post('https://github.com/login/oauth/access_token',
                          {:client_id => ENV['CLIENT_ID'],
                           :client_secret => ENV['CLIENT_SECRET'],
                           :code => params[:code]},
                           :accept => :json)

  session[:access_token] = JSON.parse(result)['access_token']

  redirect "/something"
end

get '/sign_in' do

  redirect to GithubAuth.new.authorize
end


get "/something" do
  @user = JSON.parse(RestClient.get('https://api.github.com/user',
                                   {:params => {:access_token => session[:access_token]},
                                    :accept => :json}))

  erb :something
end

get '/sign_out' do
  session.clear
  redirect '/'
end
