require 'ostruct'
require File.expand_path("../../config/boot.rb", __FILE__)
require File.expand_path("../../config/legato.rb", __FILE__)

report_intervals = [2,7,14,30,60,90,180,365]

report_intervals.each do |interval|
  puts "Checking #{interval}-day stats on all nodes ..."
  
  Node.all.each do |n|
    next if n.has_stats?(interval) || n.issue == true
    if n.pub_date < Date.today - interval.days - 1.day 
      puts "#{n.title} (#{interval}) id: #{n.id}"
      update_node_stats(n,interval,"period")
    end
  end
end

puts "Checking lifetime stats on all nodes ..."

Node.all.each do |n|
  next if n.has_current_lifetime? #|| n.pub_date < Date.today - 30.days
  age = (Date.today - n.pub_date).to_i
  puts "Update #{n.title} ... "
  update_node_stats(n,age,"lifetime")
end
