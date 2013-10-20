require File.expand_path("../../config/boot.rb", __FILE__)

authors = Hash.new(0)

Author.all.each do |a|
  nodes =  a.nodes.by_quarter(3).by_year(2013)
  if nodes.exists? 
    authors[a.name] = a.pageviews_by_quarter(3,2013)
  end
end

authors.sort { |a,b| b[1] <=> a[1]}.each do |a,b|
  puts "#{a}: #{b}"
end

  