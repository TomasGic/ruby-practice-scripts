require_relative "lib/parser.rb"
require "json"

filepath = "data/access.log"


total_requests = 0
skipped_lines = 0
method_count = Hash.new(0)
status_count = Hash.new(0)
ip_count = Hash.new(0)
paths_count = Hash.new(0)

unless File.exist?(filepath)
  puts "File not found! Script terminated"
  exit
end

File.foreach(filepath) do |line|
  if line.strip.empty?
    skipped_lines += 1
    next
  end
  log_data = parse_line(line)
  p log_data
  request_method = log_data["method"]
  status_code = log_data["status"]
  p status_code
  ip_address = log_data["ip"]
  path = log_data["path"]
  if request_method && status_code && ip_address && path
    total_requests += 1
    method_count[request_method] += 1
    status_count[status_code] += 1
    ip_count[ip_address] += 1
    paths_count[path] += 1
  else 
    puts "Incomplete request...skipping"
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
formatted_error_rate = "%.2f%%" % error_rate
puts "Total number of requests: #{total_requests}"
puts "Total number of error requests: #{total_errors}"
puts "Error percentage is approximately #{formatted_error_rate}."

final_report = {
  summary_stats: {"total_requests" => total_requests, "error rate" => formatted_error_rate},
  requests_by_status: status_count,
  requests_by_method: method_count,
  requests_by_ip_address: ip_count,
  requests_by_path: paths_count
}

File.open("data/report.json", "w") do |file|
  file.write(JSON.pretty_generate(final_report))
end
