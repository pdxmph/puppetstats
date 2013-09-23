class AddFieldsToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.integer :drupal_uid
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :drupal_uid
    end
  end
end
