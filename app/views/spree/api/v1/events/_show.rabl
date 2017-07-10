object @event

child :event_image => :event_cover_image do
    Spree::EventImage.attachment_definitions[:attachment][:styles].each do |k,v|
      node("#{k}_url") { |i| i.attachment.url(k) }
    end
end

