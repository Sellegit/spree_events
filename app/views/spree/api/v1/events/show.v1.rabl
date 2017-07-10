object false
node(:count) { @products.count }
node(:total_count) { @products.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
node(:per_page) { params[:per_page].try(:to_i) || Kaminari.config.default_per_page }
node(:pages) { @products.total_pages }

child(@event => :event) do
  extends "spree/api/v1/events/_show"
end

child(@products => :products) do
  extends "spree/api/v1/products/show"
end
