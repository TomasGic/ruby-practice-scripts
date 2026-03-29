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
      puts formatter.format(users)
    end

    private 
    def parse_options(args)
      options = { count: 5, format: "table"} # default values

      parser = OptionParser.new do |opts|
        opts.on("--count N", Integer, "Number of users to fetch") do |n|
          if n <= 0
            raise OptionParser::InvalidArgument, "Count must be a positive number!"
          else 
            options[:count] = n
          end
        end

        opts.on("--format F", "Output format (table, json)") do |f|
          options[:format] = f.downcase
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
  end
end