# Quick report of lifetime views for all employees
require File.expand_path("../../config/boot.rb", __FILE__)

authors = Author.where("kind = 'employee'")

board = Hash.new

authors.each do |a|
  board[a.name] = a.stats.where('kind = "lifetime"').sum(:pageviews)
end


board.sort_by { |author,views| views }.reverse.each do |k,v|
  puts "#{k}: #{v}"
end