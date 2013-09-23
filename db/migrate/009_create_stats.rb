class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.integer :node_id
      t.integer :period
      t.integer :pageviews
      t.integer :bounce_rate
      t.integer :visits
      t.integer :percent_new_visits
      t.string :kind
      t.timestamps
    end
  end

  def self.down
    drop_table :stats
  end
end
