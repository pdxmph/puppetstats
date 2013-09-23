require File.expand_path("../../config/boot.rb", __FILE__)

nodes = Node.all


periods = {:views_2 => 2, :views_7 => 7, :views_14 => 14, :views_30 => 30}

nodes.each do |n|

  periods.each do |k,v|
  if n.stats.find_by_period(v)
    next
  else
    legacy_views = n.send(k)
    next if n.send(k) == nil
    s = Stat.new(:node_id => n.id, :period => v, :pageviews => legacy_views, :kind => "period")
    s.save
  end
end

end