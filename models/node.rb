class Node < ActiveRecord::Base
  belongs_to :author
  has_many :stats
  has_many :refers

  # taxonomical maintenance
  scope :no_funnel, where(:taxo_funnel =>  "") 
  scope :no_theme,  where(:taxo_theme =>   "") 
  scope :no_source, where(:taxo_source =>    "")
  scope :no_type,  where(:taxo_type =>    "")
  scope :incomplete_taxo, where('taxo_source = ? OR taxo_theme = ? OR taxo_funnel = ?',"","","")
  scope :incomplete, lambda { |field| where("#{field} =  ?",'') }
  
  # taxonomical scopes
#  scope :mofu, where(:taxo_type => where())
  
  scope :funnel, lambda { |taxo| where('taxo_funnel like ?', "%#{taxo}%") }
  scope :theme, lambda { |taxo| where('taxo_theme like ?', "%#{taxo}%") }
  scope :source, lambda { |taxo| where('taxo_source like ?', "%#{taxo}%") }
    
#    User.where("name like ?", "%#{params[:query]}%").to_sql
    
  # finding things by period or time
  scope :this_quarter, where('pub_date >= ? AND pub_date <= ?', Date.today.beginning_of_quarter, Date.today.end_of_quarter)
  scope :by_month, lambda { |month|  where('extract(month from pub_date) = ?',month)}
  scope :by_year, lambda { |year| where('extract(year from pub_date) = ?',year) }
  scope :by_quarter, lambda { |quarter| where('extract(month from pub_date) <= ? AND extract(month from pub_date) >= ?',(quarter.to_i * 3 ), (quarter.to_i * 3-2)) }
  scope :past_ten, where('pub_date > ?', Date.today - 14.days)  
  scope :in_the_past, lambda { |days|  where('pub_date > ?', Date.today - days.days)}

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
  
  def stat_record(period)
    stat = self.stats.where(['period = ? AND kind = ?',period,"period"]).first
    return stat
  end

  # Return the bounce rate of a node at the given age
  def bounce_rate(period)
     stat = self.stats.where(:period => period).first
     return stat.bounce_rate
  end
  
  def percent_new_visits(period)
     stat = self.stats.where(:period => period).first
     return stat.percent_new_visits
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
  
  # Determine if the lifetime refers for a given period are fresh
  def has_current_lifetime_refers?
    if refer = self.refers.find(:first, :conditions => ["kind = ?","lifetime"])
      return refer.current?
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
  
  def has_refers?(age)
    self.refers.exists?(:period => age, :kind => "period") ? true : false
  end
  
  def self.period_report(age)
    report = OpenStruct.new
    nodes = Node.in_the_past(age).includes(:stats).where(['stats.kind = ? AND stats.period = ?', "period",7])
    report.total_nodes = nodes.size
    report.average_views = nodes.average("stats.pageviews").to_i
    report.total_views = nodes.sum("stats.pageviews").to_i
    report.average_percent_new_visitors = nodes.average("stats.percent_new_visits").to_f
    return report
  end
end
