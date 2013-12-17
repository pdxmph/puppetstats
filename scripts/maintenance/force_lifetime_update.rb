require File.expand_path("../../config/boot.rb", __FILE__)

puts "Updating lifetime stats on all nodes ..."

Node.all.each do |n|
  
  puts "Update #{n.title} ... "
  stat_record = get_stats(n.path[0,120],n.pub_date,Date.today - n.pub_date)
  stat = n.stats.find_by_kind("lifetime") || n.stats.new(:kind => "lifetime")
  stat.pageviews = stat_record.pageviews
  stat.bounce_rate = stat_record.bounce_rate
  stat.visits = stat_record.visits
  stat.period = Date.today - n.pub_date  
  stat.save
end