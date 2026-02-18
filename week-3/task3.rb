filepaths = Dir.glob("data/docs/*.md")

docs = {}

index = Hash.new { |h, k| h[k] = Hash.new(0) }

filepaths.each_with_index do |filepath, index|
  doc_id = index + 1
  filename = File.basename(filepath)
  docs[doc_id] = {path: filepath, title: filename}
end

docs.each do |doc_id, file_info|
  File.foreach(file_info[:path]) do |line|
    words = line.downcase.scan(/[a-z]+/)
    
    words.each do |word|
      index[word][doc_id] += 1
    end
  end
end

# p index


def search_word(query, index, docs)
  word = query.strip.downcase
  if index[word].empty?
    puts "No matches found"
    return
  else
    results = index[word].sort_by { |doc_id, count| -count }.to_h
  end
  mapped_results = results.map do |doc_id, count|
    if count > 1
      "Found in #{docs[doc_id][:title]} #{count} times"
    else 
      "Found in #{docs[doc_id][:title]} #{count} time"
    end
  end
  mapped_results.each { |line| puts line}
  
end

search_word("ruby", index, docs)
