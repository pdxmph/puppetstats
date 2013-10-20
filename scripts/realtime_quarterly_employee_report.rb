# Posts by employees (not marketing staff) for a given quarter
# uses realtime lifetime views 
require File.expand_path("../../config/boot.rb", __FILE__)

nodes = Node.by_year(2013).by_quarter(3).order("pub_date DESC")

records = Hash.new(0)
counts = Hash.new(0)

nodes.each do |n|
  pageviews = get_realtime_views(n)
  records["#{n.title} by #{n.author.name}"] += pageviews
  counts[n.author.name] += 1
end
  
count = 1
records.sort { |a,b| b[1] <=> a[1] }.each do |a,b|
  puts "#{count}.\t#{b} : #{a}"
  count +=1
end
