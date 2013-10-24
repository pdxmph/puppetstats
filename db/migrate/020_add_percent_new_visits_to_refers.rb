class AddPercentNewVisitsToRefers < ActiveRecord::Migration
  def self.up
    change_table :refers do |t|
      t.float :percent_new_visits
    end
  end

  def self.down
    change_table :refers do |t|
      t.remove :percent_new_visits
    end
  end
end
