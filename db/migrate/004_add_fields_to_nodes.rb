class AddFieldsToNodes < ActiveRecord::Migration
  def self.up
    change_table :nodes do |t|
      t.string :author_name
    end
  end

  def self.down
    change_table :nodes do |t|
      t.remove :author_name
    end
  end
end
