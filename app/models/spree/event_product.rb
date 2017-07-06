module Spree
  class EventProduct < Spree::Base
    belongs_to :event, class_name: 'Spree::Event'
    belongs_to :product, class_name: 'Spree::Product'
  end
end