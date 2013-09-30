# Quick "recent posts" report looking back 30 days
# Uses realtime lifetime views (so don't stretch the lookback too far)

require File.expand_path("../../config/boot.rb", __FILE__)

nodes = Node.where('pub_date > ?', Date.today - 30.days).order("pub_date DESC")
stat_intervals = [2,7,14]

nodes.each do |n|
  lifetime = get_realtime_views(n)
  stat_string = "("
  stat_intervals.each do |i|
    if n.stats.where(:period => i) && n.pageviews(i) != 0
      stat_string << "#{i}-day views: #{n.pageviews(i)}, "
    end
  end
  stat_string << "Current lifetime views: #{lifetime}"
  stat_string << ")"
  puts "#{n.pub_date.strftime("%b %d")}: #{n.title} by #{n.author.name}\n<http://puppetlabs.com#{n.path}\n#{stat_string}"
  puts "\n"
end




