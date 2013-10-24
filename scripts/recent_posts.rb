# Quick "recent posts" report looking back 30 days
# Uses realtime lifetime views (so don't stretch the lookback too far)
require File.expand_path("../../config/boot.rb", __FILE__)

nodes = Node.where('pub_date > ?', Date.today - 15.days).order("pub_date DESC")
stat_intervals = [2,7]

nodes.each do |n|
  lifetime = get_realtime_views(n)
  puts "#{n.pub_date.strftime("%b %d")}: [#{n.title}](http://puppetlabs.com#{n.path}) by #{n.author.name}\n"
  stat_intervals.each do |i|
    if n.stat_record(i)
      puts "- #{i}-day Views: #{n.stat_record(i).pageviews}, % New Visits: #{sprintf "%.1f",(n.stat_record(i).percent_new_visits)*100} \n"
    end
  end
 puts "- Current lifetime views: #{lifetime}\n"

 puts "Top Referrers:"
 
 refers = n.refers.where(:kind => "lifetime").order(:pageviews).reverse_order.limit(3)

 refers.each do |r|
   puts "   - #{r.source_medium}: #{r.pageviews} pageviews, #{sprintf "%.1f",r.percent_new_visits} % new visits"
 end
 
 puts "\n\n"
 
 
 
end