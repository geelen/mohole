class CreateScripts < ActiveRecord::Migration
  def self.up
    create_table :scripts do |t|
      t.string :base_uri
      t.text :content

      t.integer :creator_id

      t.timestamp :deleted_at
      t.timestamps
    end
  end

  def self.down
    drop_table :scripts
  end
end
