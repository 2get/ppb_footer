require 'ppb_footer/helpers'
module PpbFooter
  class Railtie < Rails::Railtie
    initializer "ppb_footer.view_helpers" do
      ActionView::Base.class_eval { include Helpers }
    end
  end
end
