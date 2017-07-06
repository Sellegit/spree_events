Deface::Override.new(
  :virtual_path => "spree/layouts/admin",
  :name => 'events_admin_tab',
  :insert_bottom => "[data-hook='admin_tabs']",
  :text => "<ul class='nav nav-sidebar'>
              <%= main_menu_tree Spree.t(:events), icon: 'file', sub_menu: 'event', url: '#sidebar-event' %>
            </ul>",
  :disabled => false
)
