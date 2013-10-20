class Author < ActiveRecord::Base

  has_many :nodes
  has_many :stats, through: :nodes
  
  
  scope :employees,  where(:kind => "employee")
  scope :marketing,  where(:kind => "staff_writer")
  scope :contributors, where(:kind => "contributor")
  
  def pageviews(period)
     stats = self.stats.where(:period => period)
     views = stats.sum(:pageviews)
     return views
  end

  def avg_pageviews(period)
    stats = self.stats.where(:period => period)
    avg_views = stats.average(:pageviews)
    return avg_views.to_f
  end
  
  def nodes_from_quarter(quarter,year)
   return self.nodes.by_year(year).by_quarter(quarter)
  end

  def node_count_by_quarter(quarter,year)
   return self.nodes.by_year(year).by_quarter(quarter).count
  end
  
  def pageviews_by_quarter(quarter,year)
    nodes = self.nodes.by_quarter(quarter).by_year(year).includes(:stats).where("stats.kind" => "lifetime")
    return nodes.sum("stats.pageviews")
  end

  def quarterly_report(quarter,year)
    
  end
end
