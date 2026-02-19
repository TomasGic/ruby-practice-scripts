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


def search_one_word(query, index, docs)
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

def search_multiple_words(query, index, docs)
  query_words = query.strip.downcase.split(/\s+/)
  first_word = query_words[0]
  other_words = query_words[1..-1]

  matching_doc_ids = index[first_word].keys
  
  other_words.each do |word|
    matching_doc_ids &= index[word].keys
    
  end

  if matching_doc_ids.empty?
    puts "No matches found"
  else
    matching_doc_ids.each do |id|
      query_words.each do |word|
        count = index[word][id]
        label = count == 1 ? "time" : "times"
        puts "#{word} found #{count} #{label} in document id #{id}."
      end
    end
  end
  
  
end

search_multiple_words("ruby analyzer", index, docs)



