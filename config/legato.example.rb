require 'google/api_client'
require 'oauth2'
require 'legato'

# Location of our API key and user address for GA backend access
@key_file = File.expand_path("../../config/ga-privatekey.p12", __FILE__)
@ga_address = ""

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
@user = service_account_user

# Identify the profile we want to pull reports for 
@profile = @user.profiles.select { |p| p.web_property_id == "UA-1537572-5" && p.name == "1 - puppetlabs.com"}.first

# Legato Reports (define the high-level dimensions and metrics we want in our functions)

# The Legato report that gives us the current engagement metrics for a given node
# used by get_stats
class PostStats
  extend Legato::Model
  metrics :pageviews, :new_visits, :bounces, :visits
  dimensions :page_path, :page_title
  filter :by_node_path, &lambda { |node_path| contains(:page_path, node_path)}
end

class PostSources
  extend Legato::Model
  metrics :pageviews, :newvisits, :visits, :bounces
  dimensions :source_medium
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

class PostStats
  extend Legato::Model
  metrics :pageviews, :new_visits, :bounces, :visits
  dimensions :page_path, :page_title
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

def update_node_refers(node,age)
  if node.pub_date < Date.today - 1.day - age.days 
    start_date = node.pub_date
    end_date = start_date + age.days
    results = @profile.post_sources(:start_date => start_date, :end_date => end_date).by_node_path(node.path[0,120]).results

    results.each do |r|
     
      @refer = node.refers.new(:period => age, 
                            :bounces => r.bounces.to_i,
                            :pageviews => r.pageviews.to_i,
                            :visits => r.visits.to_i,
                            :source_medium => r.sourceMedium
                          )
      @refer.save
     end
end
end

# This gets us the basic stats for a node for a given age
# (or for lifetime if we pass in "lifetime" as the kind parameter)
def update_node_stats(node,age,kind)
    start_date = node.pub_date
    end_date = start_date + age.days

    stat = node.stats.find(:first, :conditions => ['period = ? AND kind = ?',age,kind]) || node.stats.new(:kind => kind)
    results = @profile.post_stats(:start_date => start_date, :end_date => end_date).by_node_path(node.path[0,120]).results

    bounces = 0 
     
    results.each do |r|
      stat.pageviews += r.pageviews.to_i
      stat.visits += r.visits.to_i
      stat.new_visits += r.newVisits.to_i
      stat.period = age
      bounces += r.bounces.to_i
    end

    if bounces == 0 
      stat.bounce_rate = 0       
    else
      stat.bounce_rate = bounces.to_f/stat.visits.to_f
    end

    if stat.new_visits == 0 
      stat.percent_new_visits = 0       
    else
      stat.percent_new_visits = stat.new_visits.to_f/stat.visits.to_f
    end

    stat.save
    return "Updated #{age}-day views. (#{kind})"
end

