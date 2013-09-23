class ChangeBounceRateColumnInStats < ActiveRecord::Migration
  def self.up
    change_column :stats, :bounce_rate, :float
   end

  def self.down
    change_column :stats, :bounce_rate, :integer
  end
end
