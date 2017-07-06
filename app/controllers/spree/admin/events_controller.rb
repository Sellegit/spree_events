module Spree
  module Admin
    class EventsController < ResourceController

      before_action :load_data, except: :index

      def show
        redirect_to action: :edit
      end

      def edit
        @products = @event.products
      end

      def index
        session[:return_to] = request.url
        respond_with(@collection)
      end

      def update
        if (cover = params.maybe[:event].delete(:event_image).just)
          file = cover[:attachment]
          if file
            @event.event_image = Spree::EventImage.create!(attachment: file)
          end
        end

        super
      end

      def destroy
        @event = Spree::Event.friendly.find(params[:id])
        @event.destroy

        flash[:success] = Spree.t('notice_messages.event_deleted')

        respond_with(@event) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
        end
      end

      protected

      def find_resource
        Spree::Event.friendly.find(params[:id])
      end

      def location_after_save
        spree.edit_admin_event_url(@event)
      end

      def load_data
      end

      def collection
        return @collection if @collection.present?
        params[:q] ||= {}

        params[:q][:s] ||= "start_time_desc"
        show_hidden = params[:q].delete(:show_hidden).try(:to_i) || 1
        @collection = super
        # @search needs to be defined as this is passed to search_form_for
        @search = @collection.ransack(params[:q])
        @collection = @search.result.
          includes(event_includes).
          order(position: :asc).
          page(params[:page]).
          per(params[:per_page] || Spree::Config[:admin_products_per_page])

        @collection = @collection.where(hidden: false) if show_hidden == 0
        params[:q][:show_hidden] = show_hidden

        @collection
      end

      def event_includes
        [{:event_products => :product}]
      end

    end
  end
end
