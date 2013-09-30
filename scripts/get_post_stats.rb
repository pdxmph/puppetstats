require 'ostruct'
require File.expand_path("../../config/boot.rb", __FILE__)
require File.expand_path("../../config/legato.rb", __FILE__)

report_intervals = [2,7,14,30,60,90,180]

report_intervals.each do |interval|
  puts "Checking #{interval}-day stats on all nodes ..."
  nodes = Node.find(:all).select { |n| n.stats_from_period(interval) == 0 }  
  
  nodes.each do |n|

    if n.pub_date < Date.today - 1.day - interval.days 
      puts "#{n.title} (#{interval})"
      stat_record = get_stats(n.path[0,120],n.pub_date,interval)
      stat = n.stats.new(:pageviews => stat_record.pageviews, 
                          :bounce_rate => stat_record.bounce_rate,
                          :visits => stat_record.visits,
                          :period => interval,
                          :kind => "period")  
                          stat.save
    end
  end
end

puts "Checking lifetime stats on all nodes ..."


Node.all.each do |n|

  if  n.has_current_lifetime? == false
  puts "Update #{n.title} ... "
  stat_record = get_stats(n.path[0,120],n.pub_date,Date.today - n.pub_date)
  stat = n.stats.find_or_create_by_field(:kind => "lifetime")
  stat = n.stats.find_by_kind("lifetime") || n.stats.new(:kind => "lifetime")
  stat.pageviews = stat_record.pageviews
  stat.bounce_rate = stat_record.bounce_rate
  stat.visits = stat_record.visits
  stat.period = Date.today - n.pub_date  
  stat.save
end
end