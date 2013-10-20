class AddPageviewsToRefers < ActiveRecord::Migration
  def self.up
    change_table :refers do |t|
      t.integer :pageviews
    end
  end

  def self.down
    change_table :refers do |t|
      t.remove :pageviews
    end
  end
end
