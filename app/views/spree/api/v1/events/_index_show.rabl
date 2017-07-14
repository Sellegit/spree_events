object @event

attributes :id, :friendly_id, :title

child :event_image => :event_cover_image do
  Spree::EventImage.attachment_definitions[:attachment][:styles].each do |k,v|
    node("#{k}_url") { |i| i.attachment.url(k) }
  end
end

child(:index_products => :products) do |product|
    extends "spree/api/v1/products/show"
end
