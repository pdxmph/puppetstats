class ChangePercentnewvisitsToFloat < ActiveRecord::Migration
  def self.up
    change_column :stats, :percent_new_visits, :float
  end

  def self.down

  end
end
