require 'ostruct'
require File.expand_path("../../config/boot.rb", __FILE__)
require File.expand_path("../../config/legato.rb", __FILE__)

report_intervals = [2,7,14,30]

user = service_account_user
@profile = user.profiles.select { |p| p.web_property_id == "UA-1537572-5" && p.name == "1 - puppetlabs.com"}.first

class PostStats
  extend Legato::Model
  metrics :pageviews, :new_visits, :bounces, :visits
  dimensions :page_path, :page_title
  filter :by_node_path, &lambda { |node_path| contains(:page_path, node_path)}
end

def get_stats(path,pub_date,length)
  start_date = pub_date
  end_date = start_date + length.days

  record = OpenStruct.new(:pageviews => 0, :new_visits => 0, :visits => 0, :bounces => 0)
  results = @profile.post_stats(:start_date => start_date, :end_date => end_date).by_node_path(path).results
  
  results.each do |r|
    record.pageviews += r.pageviews.to_i
    record.visits += r.visits.to_i
    record.new_visits += r.new_visits.to_i
    record.bounces += r.bounces.to_i
  end

  record.bounce_rate = record.bounces.to_f/record.visits.to_f
  return record
end

report_intervals.each do |i|

  nodes = Node.find(:all).select { |n| n.stats_from_period(interval) == 0 }  
  
  nodes.each do |n|
    stat_record = get_stats(n.path,n.pub_date,interval)
    stat = n.stats.create(:pageviews => stat_record.pageviews, 
                          :bounce_rate => stat_record.bounce_rate,
                          :visits => stat_record.visits,
                          :period => interval,
                          :kind => "period")  
  end
end
