# Posts by employees (not marketing staff) for a given quarter
# uses realtime lifetime views 
require File.expand_path("../../config/boot.rb", __FILE__)
require File.expand_path("../../config/legato.rb", __FILE__)

nodes = Node.by_year(2013).by_quarter(3).order("pub_date DESC")

employee_counts = Hash.new(0)

nodes.by_source("employee").each do |n|
  
  pageviews = get_realtime_views(n)
    
  puts "#{n.title} by #{n.author.name} (#{pageviews})"
end
  