require 'sinatra'

set :data_path, 'data/'

get '/' do
  "API to get gender on a name."
end

get '/gender' do 
  'hello world'
end
