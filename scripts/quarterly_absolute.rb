# knockoff report to get quarterly absolute views for the blog
# Just used to validate reporting in general and eventually to match 
# incoming GA data with stored node data

require File.expand_path("../../config/boot.rb", __FILE__)
require File.expand_path("../../config/legato.rb", __FILE__)

results = get_topblog_report(3,2013)

report = Hash.new(0)

results.each do |r|
  report[r.pageTitle] += r.pageviews.to_i
end


report.sort { |a,b| b[1] <=> a[1] }.each do |k,v|
  puts "#{k}: #{v}"
end