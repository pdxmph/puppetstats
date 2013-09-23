class Stat < ActiveRecord::Base
  
  belongs_to :node

  def complete? 
    if self.pageviews && self.bounce_rate && self.visits 
      true
    else
      false
    end
  end
    
end
