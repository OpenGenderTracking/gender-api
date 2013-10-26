require 'sinatra'

set :data_path, 'data/'

get '/' do
  "API to get gender on a name."
end


# /name GET or POST a full name -- return a gender probability
get '/name' do 
end

# GET or POST fulltext -- return pronoun gender
get '/content' do
end

# GET OR POST fulltext -- return list of tokens and their likely gender
