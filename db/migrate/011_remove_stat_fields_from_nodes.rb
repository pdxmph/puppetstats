class RemoveStatFieldsFromNodes < ActiveRecord::Migration
  def self.up
    change_table :nodes do |t|
      t.remove :views_2
    t.remove :views_7
    t.remove :views_14
    t.remove :views_30
    end
  end

  def self.down
    change_table :nodes do |t|
      t.integer :views_2
    t.integer :views_7
    t.integer :views_14
    t.integer :views_30
    end
  end
end
