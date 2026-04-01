require "optparse"

module RandomPeople
  class Cli 

    SORT_FIELD_MAPPINGS = { "name" => :full_name, "age" => :age }
    MAX_NUM_USERS = 1000
    
    def initialize(service:)
      @service = service
    end

    def run(args)
      options = parse_options(args)
      users = @service.execute(count: options[:count])

      if options[:country] && !users.empty?
        users = users.select do |user| 
          user.country.upcase == options[:country].strip.upcase
        end 
      end
      
      if options[:sort] && !users.empty?
        sorting_attribute = SORT_FIELD_MAPPINGS[options[:sort]]
        if sorting_attribute
          users = sort_array(arr: users, by: sorting_attribute)
        else 
          raise OptionParser::InvalidArgument, "Invalid sort field '#{options[:sort]}'."
        end
      end

      if users.empty?
        puts "No users found"
        return
      end
      formatter = choose_formatter(options)
      puts formatter.format(users)
    rescue OptionParser::ParseError, UnsupportedFormatError => e
      abort("Usage error: #{e.message}\nTry 'bin/random_people --help' for more information")
      
    rescue ApiError => e
      abort("API Error: #{e.message}")
    
    rescue StandardError => e
      abort("An unexpected error occurred: #{e.message}")
    end

    private 
    def parse_options(args)
      options = { count: 5, format: "table", sort: nil, country: nil} # default values

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: random_people [options]"
        
        opts.on("--count N", Integer, "Number of users to fetch") do |n|
          if n <= 0
            raise OptionParser::InvalidArgument, "Count must be a positive number!"
          elsif n > MAX_NUM_USERS
            raise OptionParser::InvalidArgument, "Can only fetch max #{MAX_NUM_USERS} users."
          else
            options[:count] = n
          end
        end

        opts.on("--format F", "Output format (table, json)") do |f|
          options[:format] = f.downcase
        end

        opts.on("--sort S", "Field to sort by (name, age)") do |s|
          options[:sort] = s.downcase
        end

        opts.on("--country C", "Filter by country name") do |c|
          options[:country] = c.upcase
        end
      end
      parser.parse!(args)
      
      if args.any?
        raise OptionParser::InvalidArgument, "Unrecognized arguments: #{args.join(", ")}. Did you forget --?"
      end
      options
    end

    def choose_formatter(options)
      if options[:format] == "table"
        RandomPeople::Formatters::TableFormatter.new
      elsif options[:format] == "json"
        RandomPeople::Formatters::JsonFormatter.new
      else 
        raise UnsupportedFormatError, "Format #{options[:format]} is not supported"
      end
    end

    def sort_array(arr:, by:)
      arr.sort_by { |arr_element| arr_element.send(by) }
    end

    
  end
end