unless RssFeed.all.exists?
  VCR.configure do |c|
    c.cassette_library_dir = 'spec/vcr'
    c.hook_into :webmock
  end

  VCR.use_cassette 'lenta_response' do
    Rake::Task['rss_feeds:grub'].invoke
  end
end
