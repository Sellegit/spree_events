class CreateSpreeEvent < ActiveRecord::Migration
  def change
    create_table :spree_events do |t|
      t.integer :event_image_id
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :hidden
      t.datetime :deleted_at
      t.string :description
      t.string :slug
      t.integer :position
      t.timestamps
    end
  end
end
