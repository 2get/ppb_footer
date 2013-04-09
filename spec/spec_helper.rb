$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'fileutils'
require 'rspec'
require 'ppb_footer/view_helpers'

# stub out namespace
module Rails; end

RSpec.configure do |c|
  c.before do
    Rails.stub(:root) { File.expand_path('../..', __FILE__) }
  end

  c.after do
    FileUtils.rm_rf File.expand_path(Rails.root + '/tmp')
  end
end
