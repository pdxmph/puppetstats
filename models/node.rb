class Node < ActiveRecord::Base

  belongs_to :author
  has_many :stats
  
  scope :no_funnel, where(:taxo_funnel =>  [nil,0]) 
  scope :no_theme,  where(:taxo_theme =>   [nil,0]) 
  scope :no_source, where(:taxo_source =>    [nil,0])
  scope :no_type,  where(:taxo_type =>    [nil,0])
  scope :this_quarter, where('pub_date >= ? AND pub_date <= ?', Date.today.beginning_of_quarter, Date.today.end_of_quarter)
  scope :by_month, lambda { |month,year|  
    where('extract(month from pub_date) = ? AND extract(year from pub_date) = ?',month,year)
  }
  
  
  def pageviews(period)
    stat = self.stats.find(:first, :conditions => ['period = ?', period])
    
    if stat
      return stat.pageviews
    else
      return 0
    end
  end
  
  def bounce_rate(period)
     stat = self.stats.where(:period => period).first
     return stat.bounce_rate
  end

  def visits(period)
     stat = self.stats.where(:period => period).first
     return stat.visits
  end

  def stats_from_period(period)
    return self.stats.where(:period => period).count
  end
end
