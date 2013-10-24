class AddIssueToNode < ActiveRecord::Migration
  def self.up
    change_table :nodes do |t|
      t.boolean :issue
    end
  end

  def self.down
    change_table :nodes do |t|
      t.remove :issue
    end
  end
end
