#!/usr/bin/env ruby -I ../lib -I lib

require 'sinatra'
require 'json'
require 'yaml'
require 'confstruct'
require 'tokenizer'
require './lib/gender.rb'
require './lib/pronouns.rb'
require './lib/entities.rb'

config = Confstruct::Configuration.new(
  YAML.load_file(
    File.expand_path(
      File.join(File.dirname(__FILE__), 'config.yaml')
    )
  )
)

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

# POST text=fulltext -- return pronoun gender
post '/content' do
  content_type :json
  t = Tokenizer::Tokenizer.new
  tokens = t.tokenize params[:text]
  p = Metrics::Pronouns.new(config)
  p.process(tokens).to_json
end

# GET OR POST fulltext -- return list of tokens and their likely gender
post '/people' do
  content_type :json
  e = Metrics::Entities.new
  e.gender(params[:text]).to_json
end


__END__

@@index
" /gender?name to get the gender for the name."


