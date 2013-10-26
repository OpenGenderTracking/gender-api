require 'sinatra'
require 'json'

set :data_path, 'data/'

get '/' do
  erb :index
end

# /gender?name GET or POST a full name -- return a gender probability
get '/gender' do 
  content_type :json
  { :name => params[:name] , :gender => 'BLAH' }.to_json
end

# GET or POST fulltext -- return pronoun gender
get '/content' do
end

# GET OR POST fulltext -- return list of tokens and their likely gender


__END__

@@index
" /gender?name to get the gender for the name."


