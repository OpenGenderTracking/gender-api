require './lib/gender.rb'

module Metrics
  class Entities

    def initialize(byline=nil)
      @byline = nil
      @byline = byline.split[" "] if byline
    end

    def get_entity_tokens(text)
      result = ""
      IO.popen("./ner/nerstdin.sh", "w+") do |io|
        io.write text
        io.close_write
        result = io.read
        puts result
      end
      result.split(" ")
    end

    def get_cur_next_prev( index, tokens)
      a = tokens[index].match /(.*?)\/PERSON/
      if a
        cur = a[1]
      else
        cur = nil
      end

      b = nil
      if(index -1 >= 0)
        b = tokens[index-1].match /(.*?)\/PERSON/ 
      end
      if b
        prev = b[1]
      else
        prev = nil
      end

      c = nil
      c = tokens[index+1].match /(.*?)\/PERSON/ if index + 1 < tokens.size
      if c
        nxt = c[1]
      else
        nxt = nil
      end
      {:prev => prev, :cur => cur, :next => nxt}
    end

    def not_byline t
      return true if @byline.nil?
      @byline.each do |token|
        return nil if t[:cur] and t[:cur].downcase == token
        return nil if t[:next] and t[:next].downcase == token
        return nil if t[:prev] and t[:prev].downcase == token
      end
      return true
    end

    def get_names_for_tokens tokens
      person_instances = {}
      tokens.each_with_index do |token, i|
      #check if it is a person
        t = get_cur_next_prev(i, tokens)

        if t[:cur] and t[:next] and not_byline t
          # if this surname already exists
          if(person_instances.has_key? t[:next])

            #if there's a collision
            if person_instances[t[:next]][:first] != nil and t[:cur] != person_instances[t[:next]][:first]
              newkey = t[:cur] + " " + t[:next]

              if person_instances.has_key? newkey
                person_instances[newkey][:count] += 1
              else
                person_instances[newkey] = {:first => t[:cur], :surname => t[:next], :count=> 1}
              end

              
            else
              person_instances[t[:next]][:count]+=1
              #always add first name, in case it's missed the first time
              person_instances[t[:next]][:first] = t[:cur]
            end
          else #if the surname isn't recorded, add a new entry
            person_instances[t[:next]] = {:first => t[:cur], :surname => t[:next], :count=> 1}
          end
        end

        #if it's just one person name by itself
        if not_byline t  and t[:cur] and t[:next].nil? and t[:prev].nil?
          if(person_instances.has_key? t[:cur])
            person_instances[t[:cur]][:count]+=1
          else
            person_instances[t[:cur]] = {:first => nil, :surname => t[:cur], :count=> 1}
          end
        end

        if t[:cur] and t[:prev]
            #ignore, for now 
        end
      end
      person_instances
    end

    def gender(text)
      gender = Gender.new({:country => 'us'})
      all_names = []
      ner_tokens = get_entity_tokens(text)
      names = get_names_for_tokens ner_tokens

      this_result = {"Male"=>0, "Female"=>0, "Unknown"=>0}
      names.each_with_index do |(key,val),index|
        g = "Unknown"
        if val[:first].nil?
          g = gender.guess(key)
        else
          g = gender.guess(val[:first])
        end
        puts val[:first].to_s + " "  + val[:surname].to_s  + ": " + val[:count].to_s if g == "Unknown"
        names[key][:gender] = g
      end
      return names
    end
  end
end
