migration_superclass = if ActiveRecord::VERSION::MAJOR >= 5
  ActiveRecord::Migration["#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"]
else
  ActiveRecord::Migration
end

class CreateSpreeEventProduct < migration_superclass
  def change
    create_table :spree_event_products do |t|
      t.integer :event_id
      t.integer :product_id
      t.integer :position
      t.timestamps
    end
  end
end
