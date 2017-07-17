module Spree
  class Event < Base
    extend FriendlyId
    friendly_id :name, use: :slugged
    validates_presence_of :name, :slug

    acts_as_paranoid
    acts_as_list

    belongs_to :event_image
    has_many :event_products, -> { order(:position) }
    has_many :products, through: :event_products

    accepts_nested_attributes_for :event_image

    scope :sorted, -> { order("#{Spree::Event.table_name}.position ASC") }
    scope :visible, -> { where("#{Spree::Event.table_name}.start_time <= ?", Time.zone.now).where(hidden: false) }
    scope :not_deleted, -> { where("#{Spree::Event.quoted_table_name}.deleted_at IS NULL or #{Spree::Event.quoted_table_name}.deleted_at >= ?", Time.zone.now) }

    def available_products
      products.where('available_on is not null and available_on < ?', Time.current)
    end

    def product_ids
      products.pluck(:id)
    end

    def set_product_ids(product_ids)
      product_ids.uniq!
      origin_product_ids = event_products.pluck(:product_id)
      destroy_ids = origin_product_ids - product_ids
      Spree::EventProduct.transaction do
        event_products.where(product_id: destroy_ids).destroy_all if destroy_ids.present?
        new_product_ids = product_ids - origin_product_ids
        new_product_ids.each do |product_id|
          event_products.create(product_id: product_id)
        end
      end
    end

    attr_accessor :product_ids_string
    before_save do
      if product_ids_string
        ids = product_ids_string.split(",").map(&:to_i)
        set_product_ids(ids)
      end
    end

    def slug_candidates
      [
        :name,
        [:name, :id]
      ]
    end

    def should_generate_new_friendly_id
      name_changed? || super
    end

    def display_time_to_close
      diff = ((end_time || Time.zone.now) - Time.zone.now).seconds

      if diff <= 0
        I18n.t('event.time_to_close.now')
      elsif diff <= 24.hours
        I18n.t('event.time_to_close.in_hours', hours: (diff/1.hour).ceil)
      else
        I18n.t('event.time_to_close.in_days', days: (diff/1.day).ceil)
      end
    end

    def dynamic_attributes
      {
        display_time_to_close: display_time_to_close,
      }
    end

    def deleted?
      !!deleted_at
    end

    def index_products
      available_products.first(10)
    end

  end
end