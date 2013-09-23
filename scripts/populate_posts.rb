require File.expand_path("../../config/boot.rb", __FILE__)

require 'json'
require 'net/http'
require 'uri'
require 'active_record'
require "active_support"
require 'ostruct'

uri = URI.parse("http://puppetlabs.com/data/basic-post-data")
 
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
 
response = http.request(request)
 
if response.code == "200"
  result = JSON.parse(response.body)
  nodes = result["nodes"]

  nodes.each do |n|
    title = n['node']['title']
    author_name = n['node']['author']
    date = n['node']['date']
    theme = n['node']['taxonomy_theme'] 
    funnel = n['node']['taxonomy_funnel'] 
    source = n['node']['taxonomy_source'] 
    content = n['node']['taxonomy_content'] 
    path = n['node']['content_path']
    nid = n['node']['nid']
    uid = n['node']['uid']

    puts "#{title} (#{nid}) by #{author_name}, published on #{date}"

    unless Author.find_by_id(uid)
      author = Author.new do |a|
        a.id = uid
        a.name = author_name
        a.save
      end
    end


    unless Node.find_by_nid(nid) 
      node = Node.create
      node.title = title
      node.pub_date = Date.parse(date)
      node.author_id = uid
      node.taxo_theme = theme
      node.taxo_funnel = funnel
      node.taxo_source = source
      node.taxo_type = content
      node.path = path
      node.nid = nid
      node.author_name = author_name
      node.save
  end
end
else
  puts "Feed error (#{response.code})"
end
