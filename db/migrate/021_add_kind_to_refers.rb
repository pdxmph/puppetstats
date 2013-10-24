class AddKindToRefers < ActiveRecord::Migration
  def self.up
    change_table :refers do |t|
      t.string :kind
    end
  end

  def self.down
    change_table :refers do |t|
      t.remove :kind
    end
  end
end
