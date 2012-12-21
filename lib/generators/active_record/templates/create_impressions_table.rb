class CreateImpressionsTable < ActiveRecord::Migration
  def self.up
    create_table :impressions, :force => true do |t|
      t.string :impressionable_type
      t.integer :impressionable_id
      t.integer :user_id

      t.timestamps
    end
    add_index :impressions, [:impressionable_type, :impressionable_id], :unique => false
    add_index :impressions, :user_id
  end

  def self.down
    drop_table :impressions
  end
end
