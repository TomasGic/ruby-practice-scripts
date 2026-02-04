require_relative "lib/parser.rb"

filepath = "data/access.log"


total_requests = 0
skipped_lines = 0
method_count = Hash.new(0)
status_count = Hash.new(0)
ip_count = Hash.new(0)
paths_count = Hash.new(0)

File.foreach(filepath) do |line|
  if line.strip.empty?
    skipped_lines += 1
    next
  end
  log_data = parse_line(line)
  # p log_data
  request_method = log_data["method"]
  status_code = log_data["status"]
  ip_address = log_data["ip"]
  path = log_data["path"]
  if request_method
    total_requests += 1
    method_count[request_method] += 1
  else 
    puts "Invalid request"
  end
  if status_code
    status_count[status_code] += 1
  end
  if ip_address
    ip_count[ip_address] += 1
  end
  if path
    paths_count[path] += 1
  end
end


puts "Requests by method"
p method_count

puts "Request by status"
p status_count

puts "Requests by IP address"
p ip_count

puts "Requests by path"
p paths_count

error_counts = status_count.select { |status, count| status.to_i >= 400 }
total_errors = error_counts.values.sum
error_rate = total_errors.to_f/total_requests * 100
puts "Total number of requests: #{total_requests}"
puts "Total number of error requests: #{total_errors}"
puts "Error percentage is approximately #{'%.2f' % error_rate}%."


