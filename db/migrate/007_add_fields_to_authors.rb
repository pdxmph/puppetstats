class AddFieldsToAuthors < ActiveRecord::Migration
  def self.up
    change_table :authors do |t|
      t.integer :drupal_uid
    end
  end

  def self.down
    change_table :authors do |t|
      t.remove :drupal_uid
    end
  end
end
