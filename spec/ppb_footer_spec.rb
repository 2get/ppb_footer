require 'spec_helper'

describe PpbFooter::ViewHelpers do
  let(:content) { described_class.open_with_cache('30days') }

  %w(lolipop.gif heteml.gif sqale.gif muumuu.gif 30days.gif jugem.gif the.gif calamel.gif puboo.gif booklog.gif minne.gif goope.gif colormeshop.gif jugemcart.gif petit.gif osaipo.gif apps.gif timercamera.gif denpa.gif).each do |app|
    it { content.should include app }
  end
end
