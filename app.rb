require 'sinatra/base'
require './lookup'

class HstsPreload < Sinatra::Base
  get '/' do
    #display home page
    cache_control :public, :max_age => 36000
    erb :index
  end

  get '/api/v1/status/:domain' do
    content_type :json
    cache_control :public, :max_age => 3600
    Lookup.get_status params['domain']
  end
end
