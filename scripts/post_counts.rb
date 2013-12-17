require File.expand_path("../../config/boot.rb", __FILE__)

quarters = [1,2,3,4]
years = [2008,2009,2010,2011,2012,2013]

years.each do |y|
  puts "\n#{y}: #{Node.by_year(y).count}"
  puts "------------"
  
quarters.each do |q|
  nodes =  Node.by_quarter(q).by_year(y)
  puts "\tQ#{q}: #{nodes.count}\n"
end
end