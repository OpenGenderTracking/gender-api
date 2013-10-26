require 'csv'
require 'set'

class Gender
  def initialize(options={})
    countries = Set.new([:us, :uk])

    @threshold = options[:threshold] || 0.99

    @names_counts = {}
    # @country_totals = {}
    @names_genders = {}

    if options[:country]
      countries &= options[:country].map(&:to_sym)
    end

    #TODO: "piecewise" loading to avoid ~10sec delay when loading into memory (e.g. seeking around the file?)
    countries.each do |country|
      CSV.open("lib/data/#{country}processed.csv", :headers => true).each do |row|
        @names_counts[row["Name"]] = {
                                  :male => @names_counts.fetch(row["Name"], {}).fetch(:male, 0) + row["counts.male"].to_i,
                                  :female => @names_counts.fetch(row["Name"], {}).fetch(:female, 0) + row["counts.female"].to_i,
                                  :total => @names_counts.fetch(row["Name"], {}).fetch(:total, 0) + row["counts.female"].to_i  + row["counts.male"].to_i
                                }
        # @country_totals[country] = (country_totals[country] || 0) + row["counts.male"] + row["counts.female"]
      end
    end
    @names_counts.each do |name, counts|
      @names_genders[name] =  if counts[:male] > @threshold * counts[:total]
                                :male
                              elsif counts[:female] > @threshold * counts[:total]
                                :female
                              else
                                :unknown
                              end
    end
    self
  end

  def normalize(name)
    #TODO: do that weird char map thing to eliminate non-alpha chars
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
