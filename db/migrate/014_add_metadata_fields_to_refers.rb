class AddMetadataFieldsToRefers < ActiveRecord::Migration
  def self.up
    change_table :refers do |t|
      t.integer :node_id
    t.integer :period
    end
  end

  def self.down
    change_table :refers do |t|
      t.remove :node_id
    t.remove :period
    end
  end
end
