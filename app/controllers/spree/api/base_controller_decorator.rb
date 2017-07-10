Spree::Api::BaseController.class_eval do
  def find_event(id)
    event_scope.friendly.distinct(false).find(id.to_s)
  rescue ActiveRecord::RecordNotFound
    event_scope.find(id)
  end

  def event_scope
    if @current_user_roles.include?("admin")
      scope = Spree::Event.with_deleted.accessible_by(current_ability, :read).includes(*event_includes)

      unless params[:show_deleted]
        scope = scope.not_deleted
      end
    else
      scope = Spree::Event.visible.accessible_by(current_ability, :read).active.includes(*event_includes)
    end

    scope
  end

  def event_includes
    [ :event_products, :products ]
  end
end