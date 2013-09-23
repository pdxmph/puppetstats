class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.string :title
      t.integer :author_id
      t.string :taxo_type
      t.string :taxo_funnel
      t.string :taxo_theme
      t.string :taxo_source
      t.date :pub_date
      t.string :path
      t.integer :nid
      t.timestamps
    end
  end

  def self.down
    drop_table :nodes
  end
end
