class AddBouncrateToRefers < ActiveRecord::Migration
  def self.up
    change_table :refers do |t|
      t.float :bounce_rate
    end
  end

  def self.down
    change_table :refers do |t|
      t.remove :bounce_rate
    end
  end
end
