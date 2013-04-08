require "ppb_footer/version"
require "ppb_footer/helpers"

ActionView::Base.class_eval { include PpbFooter::Helper }

ActionController::Base.prepend_view_path File.expand_path("../ppb_footer/views", __FILE__)
