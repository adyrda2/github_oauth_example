class GithubAuth
  attr_reader :github

  def initialize
    @github = Github.new(client_id: ENV['CLIENT_ID'],
                          client_secret: ENV['CLIENT_SECRET'])
  end

  def authorize
    github.authorize_url(redirect_uri: 'http://localhost:9393/callback',
                          scope: 'user,repo')
  end
end
