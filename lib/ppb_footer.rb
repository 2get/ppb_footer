require 'ppb_footer/version'

if defined?(Rails::Railtie)
  require 'ppb_footer/railtie'
else
  require 'ppb_footer/helpers'
  ActionView::Base.class_eval { include PpbFooter::ViewHelpers }
end

ActionController::Base.prepend_view_path File.expand_path("../ppb_footer/views", __FILE__)
