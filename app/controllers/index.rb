enable :sessions

get '/' do

  erb :index, :locals => {:client_id => ENV['CLIENT_ID']}
end

get '/callback' do

  session_code = request.env['rack.request.query_hash']['code']

  result = RestClient.post('https://github.com/login/oauth/access_token',
                          {:client_id => ENV['CLIENT_ID'],
                           :client_secret => ENV['CLIENT_SECRET'],
                           :code => session_code},
                           :accept => :json)

  session[:access_token] = JSON.parse(result)['access_token']

  redirect "/something"
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
