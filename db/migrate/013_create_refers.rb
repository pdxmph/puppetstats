class CreateRefers < ActiveRecord::Migration
  def self.up
    create_table :refers do |t|
      t.string :source_medium
      t.integer :visits
      t.integer :newvisits
      t.integer :bounces
      t.timestamps
    end
  end

  def self.down
    drop_table :refers
  end
end
