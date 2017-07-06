Spree::Product.class_eval do
  has_many :event_products, inverse_of: :product, dependent: :destroy
  has_many :events, through: :event_products
end
