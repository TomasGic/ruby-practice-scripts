def find_first_heading(filepath)
  File.foreach(filepath) do |line|
    next if line.strip.empty?
    array_of_matches = line.scan(/^#\s+(.+)/).flatten
    return array_of_matches[0] if array_of_matches.any?
  end
  return "N/A"
end


def count_words(filepath)
  word_count = 0
  File.foreach(filepath) do |line|
    next if line.strip.empty?
    word_count += line.split.size
  end
  return word_count
end


def count_tags(filepath)
  number_of_tags = 0
  File.foreach(filepath) do |line|
    next if line.strip.empty?
    array_of_matches = line.scan(/#(\w+)/).flatten
    if array_of_matches.any?
      number_of_tags += array_of_matches.length
    end
  end
  return number_of_tags
end


def find_most_common_words(filepaths)
  word_counts = Hash.new(0)
  stopwords = Set.new([
    "the", "this", "a", "an", "is", "of", "as", "that", "which", "what", "it", 
    "on", "we", "to", "in", "and", "if", "all", "from", "for", "by", "how"
  ])
  filepaths.each do |filepath|
    File.foreach(filepath) do |line| 
      next if line.strip.empty?
      words = line.downcase.gsub(/[^a-z0-9\s]/, '').split
      
      words.each do |word|
        unless stopwords.include?(word)
          word_counts[word] += 1
        end
      end
    end
  end
  
  return word_counts.sort_by { |word, count| -count }.first(30).to_h
end



filepaths = Dir.glob("../**/*.md")
number_of_files = filepaths.length
global_word_count = 0

filepaths.each do |filepath|
  file_metadata = {}

  word_count = count_words(filepath)
  global_word_count += word_count
  
  file_metadata[:path] = filepath
  file_metadata[:words] = word_count
  file_metadata[:first_heading] = find_first_heading(filepath)
  file_metadata[:tags] = count_tags(filepath)
  p file_metadata
  
end

puts "\n"
puts "Total number of markdown files in the project directory is #{number_of_files}."
puts "Total number of words across all markdown files is #{global_word_count}."
puts "\n"
puts "30 most common words across all markdown files:\n"
puts find_most_common_words(filepaths)




