filepaths = Dir.glob("../**/*.md")

word_counts = []

filepaths.each do |filepath|
  word_count = 0
  file_metadata = {
    path: filepath,
    word_count: word_count
  }
  File.foreach(filepath) do |line|
    word_count += line.split.size
  end
  
  file_metadata[:word_count] = word_count
  word_counts.push(file_metadata)
end

p word_counts
