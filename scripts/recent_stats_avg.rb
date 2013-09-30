# Report summarizing recent average stats for given periods
require File.expand_path("../../config/boot.rb", __FILE__)

intervals = [2,7,14,30]

intervals.each do |i|
  views = 0 
  stats = Stat.all.select { |s| s.node.pub_date > Date.today - 60.days && s.period == i }
  
  stats.each do |s|
    views += s.pageviews
  end

  avg_views = views/stats.length
  puts "#{i}-day average views for past 60 days: #{avg_views}"

end

