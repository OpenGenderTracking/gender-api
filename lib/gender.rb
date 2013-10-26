require 'csv'
require 'set'

class Gender

  def initialize(options)

    countries = Set.new([:us, :uk])
    threshold = options[:threshold] || 0.99

    names_counts = get_names_counts(threshold, countries)

    @names_genders = {}
    names_counts.each do |name, counts|
      @names_genders[name] = get_gender(counts, threshold)
    end
  end
 
  def get_names_counts(threshold, countries)
    names_counts  = {}
    countries.each do |country|
      file_path = "lib/metrics/names/#{country}processed.csv"
      CSV.open(file_path, :headers => true).each do |row|
        names_counts[row["Name"]] = {
            :male =>   names_counts.fetch(row["Name"], {}).fetch(:male, 0) + row["counts.male"].to_i,
            :female => names_counts.fetch(row["Name"], {}).fetch(:female, 0) + row["counts.female"].to_i,
            :total =>  names_counts.fetch(row["Name"], {}).fetch(:total, 0) + row["counts.female"].to_i  + row["counts.male"].to_i
        }
      end
    end

    return names_counts
  end

  def get_gender(counts, threshold)
    if counts[:male] > threshold * counts[:total]
      return :male
    elsif counts[:female] > threshold * counts[:total]
      return :female
    else
      return :unknown
    end
  end

  def normalize(name)
    if name.include?(" ")
      name = name[0...name.index(" ")]
    end
    name[0].upcase + name[1..-1]
  end

  def guess(name)
    @names_genders.fetch(normalize(name), :unknown)
  end

  def maleness_ratio(name)
    1 - femaleness_ratio(name)
  end

  def femaleness_ratio(name)
    @names_counts[normalize name][:female].to_f /  @names_counts[normalize name][:total]
  end
end
