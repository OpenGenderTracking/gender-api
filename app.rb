require 'sinatra'
require 'json'
require './lib/gender.rb'

set :data_path, 'data/'


gender = Gender.new({:country => 'us'})

get '/' do
  erb :index
end

# /gender?name GET or POST a full name -- return a gender probability
get '/gender' do 
  content_type :json
  { :name => params[:name], :gender => gender.guess(params[:name]) }.to_json
  #{ :name => params[:name] , :gender => 'BLAH' }.to_json
end

# GET or POST fulltext -- return pronoun gender
get '/content' do
end

# GET OR POST fulltext -- return list of tokens and their likely gender


__END__

@@index
" /gender?name to get the gender for the name."


