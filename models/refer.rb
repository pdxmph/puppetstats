class Refer < ActiveRecord::Base

  belongs_to :node
  
  scope :lifetime, where(:kind => "lifetime")
  scope :social, where('source_medium LIKE ?', '%/ socnet%')
  scope :by_source, lambda { |source_medium| where('source_medium LIKE ?', "%#{source_medium} /%")}
  scope :by_medium, lambda { |source_medium| where('source_medium LIKE ?', "%/ #{source_medium}%")}
  scope :by_age, lambda { |age| where('period = ?', age)}



  
  # When was the stat last updated in days? Used to find "lifetime" stats 
  # that need to be refreshed via the current? method. We could move this 
  # into the current? method
  def age
    return (Date.today - self.updated_at.to_date).to_i
  end
  
  # Determine if a view is "current" depending on the parent node's age
  # We use this to look for "expired" lifetime views every now and then
  def current?
    if self.node.age > 365 && self.age > 30
      return false
    elsif self.node.age > 180 && self.age > 14 
      return false
    elsif self.node.age >= 30 && self.age > 7 
      return false
    elsif self.node.age < 30 && self.age > 2
      return false
    else 
      return true
    end
  end
  
  def self.refers_by_period(start_date,end_date)
    return self.includes('node').where('nodes.pub_date' => start_date..end_date)
  end
  

  
end
