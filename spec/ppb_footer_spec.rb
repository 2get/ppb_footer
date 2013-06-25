# -*- coding: utf-8 -*-
require 'spec_helper'

describe PpbFooter::ViewHelpers do
  context do
    let(:content) { described_class.open_with_cache('30days') }

    %w(lolipop.gif heteml.gif sqale.gif muumuu.gif 30days.gif jugem.gif the.gif calamel.gif puboo.gif booklog.gif minne.gif goope.gif colormeshop.gif jugemcart.gif petit.gif osaipo.gif apps.gif timercamera.gif denpa.gif).each do |app|
      it { content.should include app }
    end
  end

  context do
    let(:content) { described_class.render_pc_footer }

    %w(
      http://calamel.jp/
      http://p.booklog.jp/
      http://booklog.jp/
      http://minne.com/
      http://shop-pro.jp/
      http://ja.jugemcart.com/
      http://jugem.jp/
      http://jugem.jp/service/plus/
      http://30d.jp/
      http://theinterviews.jp/
      https://play.google.com/store/apps/details?id=jp.co.paperboy.optimizer.onigiri
      http://goope.jp/
      http://www.petit.cc/
      http://lolipop.jp/
      http://heteml.jp/
      http://sqale.jp/
      http://muumuu-domain.com/
      http://osaipo.jp/
    ).each do |url|
      it { content.should include url }
    end
  end

  context 'OpenURI::open_uriでTimeoutErrorが発生する場合' do
    let(:content) { described_class.render_pc_footer }
    
    before do
      OpenURI.stub(:open_uri).and_raise TimeoutError
    end

    %w(
      http://calamel.jp/
      http://p.booklog.jp/
      http://booklog.jp/
      http://minne.com/
      http://shop-pro.jp/
      http://ja.jugemcart.com/
      http://jugem.jp/
      http://jugem.jp/service/plus/
      http://30d.jp/
      http://theinterviews.jp/
      https://play.google.com/store/apps/details?id=jp.co.paperboy.optimizer.onigiri
      http://goope.jp/
      http://www.petit.cc/
      http://lolipop.jp/
      http://heteml.jp/
      http://sqale.jp/
      http://muumuu-domain.com/
      http://osaipo.jp/
    ).each do |url|
      it 'フッタをレンダリングできること' do
        content.should include url
      end
    end
  end

  context 'CSV::parseでCSV::MalformedCSVErrorが発生する場合' do
    let(:content) { described_class.render_pc_footer }
    
    before do
      CSV.stub(:parse).and_raise CSV::MalformedCSVError
    end

    it { content.should eq '' }
  end
end
