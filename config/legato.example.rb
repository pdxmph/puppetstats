# Sample file 
require 'google/api_client'
require 'oauth2'
require 'legato'

# Location of our API key and user address for GA backend access
# To generate your own, see here: 
# <https://github.com/tpitale/legato/wiki/OAuth2-and-Google>
@key_file = File.expand_path("../../config/ga-privatekey.p12", __FILE__)
@ga_address = "ga_api_email_address"

# Set up OAuth 
def service_account_user(scope="https://www.googleapis.com/auth/analytics.readonly")
   client = Google::APIClient.new(:application_name => "console_analytics")
   key = Google::APIClient::PKCS12.load_key(@key_file,"notasecret")
   service_account = Google::APIClient::JWTAsserter.new(@ga_address, scope, key)
   client.authorization = service_account.authorize
   oauth_client = OAuth2::Client.new("", "", {
      :authorize_url => 'https://accounts.google.com/o/oauth2/auth',
      :token_url => 'https://accounts.google.com/o/oauth2/token'
   })
   token = OAuth2::AccessToken.new(oauth_client, client.authorization.access_token)
   Legato::User.new(token)
end

# Initiate a user 
user = service_account_user

# Identify the profile we want to pull reports for 
@profile = user.profiles.select { |p| p.web_property_id == "GA Property ID" && p.name == "GA Property Name"}.first

# Legato Reports (define the high-level dimensions and metrics we want in our functions)

# The Legato report that gives us the current engagement metrics for a given node
# used by get_stats
class PostStats
  extend Legato::Model
  metrics :pageviews, :new_visits, :bounces, :visits
  dimensions :page_path, :page_title
  filter :by_node_path, &lambda { |node_path| contains(:page_path, node_path)}
end

# The Legato report that gives us the current pageviews for a given node
# used by get_realtime_views
class RealtimeViews
  extend Legato::Model
  metrics :pageviews
  dimensions :page_path
  filter :by_node_path, &lambda { |node_path| contains(:page_path, node_path)}
end

# The Legato report that gives us the top blog entries for the get_top_blog_report function
class TopBlog
  extend Legato::Model
  metrics :pageviews
  dimensions :page_path, :page_title
  filter :by_node_path, &lambda { |node_path| contains(:page_path, node_path)}
end

# Functions (define basic reporting functions that use the Legato reports above)

# Get all the numbers for the blog for a given quarter/year
# This can be duplicated pretty easily in GA with a custom report filtering on the path, 
# but having it here makes it easier to pull into a rollup
def get_topblog_report(quarter,year)

  start_month = (quarter * 3)  - 2
  start_date = Date.parse("#{year}-#{start_month}-01")
  end_date = start_date.end_of_quarter
  
  results = @profile.top_blog(:start_date => start_date, :end_date => end_date, :sort => "-pageviews").by_node_path('/puppetlabs.com/blog/').results
  
  return results
  
end


# This gets us the current lifetime views of any node
# Typically this will be used in conjunction with the by-quarter or by-month scopes in the Node model
def get_realtime_views(node)
  start_date = node.pub_date
  end_date = Date.today
  
  results = @profile.realtime_views(:start_date => start_date, :end_date => end_date).by_node_path(node.path).results
  
  pageviews = 0
  results.each do |r|
    pageviews += r.pageviews.to_i
  end
  
  return pageviews
  
end

# This gets us the views of a given node at a given number of days since publication
# TODO: Just pass in the node instead of its path and pub_date
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

  unless record.bounces == 0 
    record.bounce_rate = record.bounces.to_f/record.visits.to_f
  else
    record.bounce_rate = 0 
  end

  return record
end

