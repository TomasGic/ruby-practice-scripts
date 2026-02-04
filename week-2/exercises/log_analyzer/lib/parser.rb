def parse_line(line)
  timestamp = line.split(" ", 2).first
  parsed_line = line.scan(/(\w+)=([^\s]+)/).to_h
  parsed_line["timestamp"] = timestamp
  return parsed_line
end

