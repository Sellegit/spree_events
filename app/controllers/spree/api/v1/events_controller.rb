module Spree
  module Api
    module V1
      class EventsController < Spree::Api::BaseController
        def index
          if params[:ids]
            @events = event_scope.where(id: params[:ids].split(",").flatten)
          else
            @events = event_scope.ransack(params[:q]).result
          end

          @events = @events.distinct.page(params[:page]).per(params[:per_page])
          expires_in 15.minutes, public: true
          headers['Surrogate-Control'] = "max-age=#{15.minutes}"
          respond_with(@events)
        end

        def show
          @event = find_event(params[:id])
          @products = @event.available_products.page(params[:page]).per(params[:per_page])
          expires_in 15.minutes, public: true
          headers['Surrogate-Control'] = "max-age=#{15.minutes}"
          headers['Surrogate-Key'] = "event_id=1"
          respond_with(@event, @products)
        end

        def popular_events
          @events = event_scope.sorted.visible.first(3);
        end
      end
    end
  end
end