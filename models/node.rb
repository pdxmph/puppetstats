class Node < ActiveRecord::Base

  belongs_to :author
  has_many :stats
  
  scope :no_funnel, where(:taxo_funnel =>  [nil,0]) 
  scope :no_theme,  where(:taxo_theme =>   [nil,0]) 
  scope :no_source, where(:taxo_source =>    [nil,0])
  scope :no_type,  where(:taxo_type =>    [nil,0])
  scope :this_quarter, where('pub_date >= ? AND pub_date <= ?', Date.today.beginning_of_quarter, Date.today.end_of_quarter)


  def pageviews(period)
     stat = self.stats.where(:period => period).first
     return stat.pageviews
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
