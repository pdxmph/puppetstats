#!/usr/bin/env ruby 

# Quick "recent posts" report looking back 30 days
# Uses realtime lifetime views (so don't stretch the lookback too far)

require File.expand_path("../../config/boot.rb", __FILE__)

puts "Recent Posts Report - Generated #{Date.today.strftime("%Y-%m-%d")}\n\n" 

#nodes = Node.where('pub_date > ?', Date.today - 15.days).order("pub_date DESC")

nodes = Node.in_the_past(15).includes(:refers).where(['refers.kind = ?', "lifetime"]).order("pub_date DESC")

avg_percent_new_visits =  nodes.average("refers.percent_new_visits")

avg_pnv_mark  = avg_percent_new_visits + (avg_percent_new_visits/4)

puts "Average % new visits from referrers for period: #{sprintf "%.1f",avg_percent_new_visits} <span style='color:red;font-weight:heavy;'>(&gt; #{sprintf "%.1f",avg_pnv_mark})</span>\n\n"

stat_intervals = [2,7]
all_lifetime = 0 

nodes.each do |n|
  lifetime = get_realtime_views(n)
  all_lifetime += lifetime
  puts "**[#{n.title}](http://puppetlabs.com#{n.path})** by #{n.author.name} on #{n.pub_date.strftime("%b %d")}"
  stat_intervals.each do |i|
    if n.stat_record(i)
      puts "- #{i}-day Views: #{n.stat_record(i).pageviews}, % New Visits: #{sprintf "%.1f",(n.stat_record(i).percent_new_visits)*100} \n"
    end
  end
 puts "- Current lifetime views: #{lifetime}\n"

 puts "**Top Referrers (Lifetime):**"
 
 refers = n.refers.where(:kind => "lifetime").order(:pageviews).reverse_order.limit(3)

 refers.each do |r|
   
   if r.percent_new_visits > avg_pnv_mark 
     pnv = "<span style='color:red;font-weight:bold;'>#{sprintf "%.1f",r.percent_new_visits} % new visits</span>"
   else
     pnv = "#{sprintf "%.1f",r.percent_new_visits} % new visits"
   end

   puts "   - #{r.source_medium}: #{r.pageviews} pageviews, #{pnv}"
   
 end
 
 puts "\n\n"
 
 sleep 1
  
end

puts "Total lifetime views: #{all_lifetime}"
puts "Average lifetime views: #{sprintf "%.1f",all_lifetime/nodes.count}"
