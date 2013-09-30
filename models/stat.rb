class Stat < ActiveRecord::Base
  belongs_to :node

  # Find all the "lifetime" stats 
  scope :lifetime, where(:kind => "lifetime")


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

  # This method helps us find stats that aren't complete for whatever reason (most likely because the
  # stats being gathered have changed and we haven't updated all the gathered items).
  def complete? 
    if self.pageviews && self.bounce_rate && self.visits 
      true
    else
      false
    end
  end


end
