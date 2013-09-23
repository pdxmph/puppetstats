require File.expand_path("../../config/boot.rb", __FILE__)

authors = Author.where("kind = 'staff_writer'")

authors.each do |a|
  puts "#{a.name} (#{a.nodes.count} posts)"
  puts "\t Avg. 7-Day Views: #{a.stats.where('period = 7').average(:pageviews).to_f}"  
  puts "\t Lifetime 7-Day Views: #{a.stats.where('period = 7').sum(:pageviews)}" 
  puts "\t Most 30-Day Views, Single Post: #{a.stats.where('period = 30').maximum(:pageviews)}" 
  puts "\n\n\n"
end