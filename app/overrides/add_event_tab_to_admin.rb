Deface::Override.new(
  :virtual_path => "spree/layouts/admin",
  :name => 'events_admin_tab',
  :insert_bottom => "#main-sidebar",
  :partial => 'spree/admin/shared/events_sidebar_menu'
)