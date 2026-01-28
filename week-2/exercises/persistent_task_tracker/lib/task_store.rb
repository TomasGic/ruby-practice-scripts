require 'json'

FILEPATH = "data/tasks.json"

def load_tasks()
  if File.exist?(FILEPATH)
    begin
      file_content = File.read(FILEPATH)
      parsed_content = JSON.parse(file_content, symbolize_names: true)
    rescue
      parsed_content = []
    return parsed_content
    end
  else 
    return []
  end
end

def save_tasks(tasks)
  File.open(FILEPATH, "w") do |file|
    file.write(JSON.pretty_generate(tasks))
  end
end

