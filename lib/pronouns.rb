module Metrics
  class Pronouns

    def initialize(config)
      @config = config
      @pronouns = {
        :male => read_type("male"),
        :female => read_type("female"),
        :neutral => read_type("neutral")
      }
    end

  
    def get_name
      return "pronouns"
    end
  

    def process(tokens)
      # count how many tokens fall within the pronoun dictionary
      counts = { :male => 0, :female => 0, :neutral => 0 }
      tokens.each do |token|
        m = @pronouns[:male].index(token)
        if (!m.nil?)
          counts[:male] += 1
        else
          f = @pronouns[:female].index(token)
          if (!f.nil?)
            counts[:female] += 1
          else
            n = @pronouns[:neutral].index(token)
            if (!n.nil?)
              counts[:neutral] += 1
            end
          end
        end
      end

      score = { :result => "", :counts => counts }
      if ((counts[:male] + counts[:female]) == 0)
        score[:result] = "Unknown"
      elsif (counts[:neutral] > (counts[:male] + counts[:female]))
        score[:result] = "Neutral"
      else
        male_percent = counts[:male].to_f / (counts[:male] + counts[:female])
        if (male_percent > 0.66)
          score[:result] = "Male"
        elsif (male_percent > 0.33)
          score[:result] = "Neutral"
        else
          score[:result] = "Female"
        end
      end

      score
    end


    private
    def read_type(type)
      File.open(
        File.expand_path(
          File.join(
            File.dirname(__FILE__), 
            "../lib/metrics/pronouns/#{type}-#{@config.lang}.csv"
          )
        ), "r"
      ).read.split("\n")
    end 
  end
end
