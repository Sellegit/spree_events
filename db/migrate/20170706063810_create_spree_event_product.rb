class CreateSpreeEventProduct < ActiveRecord::Migration
  def change
    create_table :spree_event_products do |t|
      t.integer :event_id
      t.integer :product_id
      t.integer :position
      t.timestamps
    end
  end
end
