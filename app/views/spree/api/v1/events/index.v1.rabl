object false

node(:count) { @events.count }
node(:total_count) { @events.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page].try(:to_i) || Kaminari.config.default_per_page }
node(:pages) { @events.total_pages }
child(@events => :events) do
  extends "spree/api/v1/events/_index_show"
end

