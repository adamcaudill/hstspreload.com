require 'sinatra/base'
require './lookup'

class HstsPreload < Sinatra::Base
  get '/' do
    #display home page
    erb :index
  end

  get '/api/v1/status/:domain' do
    content_type :json
    Lookup.get_status params['domain']
  end
end
