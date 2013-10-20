require 'ostruct'
require File.expand_path("../../config/boot.rb", __FILE__)
require File.expand_path("../../config/legato.rb", __FILE__)

report_intervals = [7,14,30]

report_intervals.each do |interval|
  puts "Checking #{interval}-day stats on all nodes ..."
  
  Node.all.each do |n|
    next if n.refers.exists?(:period => interval)
    if n.pub_date < Date.today - 1.day - interval.days 
      puts "#{n.title} (#{interval})"
      puts update_node_refers(n,interval)
    end
  end
end



