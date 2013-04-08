module PpbFooter
  class Railtie < Rails::Railtie
    initializer "ppb_footer.view_helpers" do
      require 'ppb_footer/view_helpers'
      ActionView::Base.class_eval { include ViewHelpers }
    end
  end
end
