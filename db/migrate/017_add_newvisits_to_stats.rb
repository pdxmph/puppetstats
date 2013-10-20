class AddNewvisitsToStats < ActiveRecord::Migration
  def self.up
    change_table :stats do |t|
      t.integer :new_visits
    end
  end

  def self.down
    change_table :stats do |t|
      t.remove :new_visits
    end
  end
end
