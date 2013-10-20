class Node < ActiveRecord::Base
  belongs_to :author
  has_many :stats
  has_many :refers

  # taxonomical considerations  
  scope :no_funnel, where(:taxo_funnel =>  "") 
  scope :no_theme,  where(:taxo_theme =>   "") 
  scope :no_source, where(:taxo_source =>    "")
  scope :no_type,  where(:taxo_type =>    "")
  scope :incomplete_taxo, where('taxo_source = ? OR taxo_theme = ? OR taxo_funnel = ?',"","","")
  scope :incomplete, lambda { |field| where("#{field} =  ?",'') }
  
  
  # finding things by period or time
  scope :this_quarter, where('pub_date >= ? AND pub_date <= ?', Date.today.beginning_of_quarter, Date.today.end_of_quarter)
  scope :by_month, lambda { |month|  where('extract(month from pub_date) = ?',month)}
  scope :by_year, lambda { |year| where('extract(year from pub_date) = ?',year) }
  scope :by_quarter, lambda { |quarter| where('extract(month from pub_date) <= ? AND extract(month from pub_date) >= ?',(quarter.to_i * 3 ), (quarter.to_i * 3-2)) }
  scope :past_ten, where('pub_date > ?', Date.today - 14.days)  

  
  # Find by "employee", "staff_writer" etc. This will fall away once we have the taxonomy back-ported
  def self.by_source(source)
    Node.includes(:author).where('authors.kind = ?',source)
  end
  
  # Return the age of a node in days
  def age
    return (Date.today - self.pub_date).to_i
  end
  
  # Return the pageviews of a node, generally gathered at 2,7,14 30 and every 30 days thereafter
  def pageviews(period)
    stat = self.stats.find(:first, :conditions => ['period = ?', period])
    if stat
      return stat.pageviews
    else
      return 0
    end
  end
  
  # Return the bounce rate of a node at the given age
  def bounce_rate(period)
     stat = self.stats.where(:period => period).first
     return stat.bounce_rate
  end

  # Return the visits to a node at the given age
  def visits(period)
     stat = self.stats.where(:period => period).first
     return stat.visits
  end

  # Return how many stats of a given period exist
  # Should never be anything besides 1 or 0
  def stats_from_period(period)
    return self.stats.where(:period => period).count
  end
  
  # Determine if the lifetime stats for a given period are fresh
  def has_current_lifetime?
    if stat = self.stats.find(:first, :conditions => ["kind = ?","lifetime"])
      return stat.current?
    else
      return false
    end
  end
  
  # Show lifetime views for a stat as of last general gather
  def lifetime_views
    return self.stats.where(:kind => "lifetime").first.pageviews
  end
  
  # Show lifetime views for a stat as of right now
  def realtime_lifetime
    get_realtime_views(self)
  end

  def has_stats?(age)
    self.stats.exists?(:period => age) ? true : false
  end
end
