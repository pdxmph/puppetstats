class Author < ActiveRecord::Base

  has_many :nodes
  has_many :stats, through: :nodes
  
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
  
  
     
end
