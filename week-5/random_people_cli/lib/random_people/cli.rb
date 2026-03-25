require "optparse"

module RandomPeople
  
  
  class Cli 
    def initialize(service:)
      @service = service
    end

    def run(args)
      options = parse_options(args)
      formatter = choose_formatter(options)
      users = @service.execute(count: options[:count])
      formatter.format(users)
    end

    private 
    def parse_options(args)
      options = { count: 5, format: "table"} # default value

      OptionParser.new do |opts|
        opts.on("--count N", "Number of users to fetch") do |n|
          options[:count] = n.to_i
        end

        opts.on("--format F", "Output format (table, json)") do |f|
          options[:format] = f.downcase
        end
      end.parse!(args)
      return options
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
  end
end