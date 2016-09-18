require 'spec_helper'
require 'rake'

RSpec.describe 'rss_feeds:grub' do
  before { ::LentaRssScraper::Application.load_tasks }

  it "should fetch and save rss items" do 
    VCR.use_cassette 'lenta_response' do
      Rake::Task['rss_feeds:grub'].invoke
    end
    expect(RssFeed.count).to be > 0
  end
end
