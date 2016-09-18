require "rails_helper"
require_relative "shared_examples/rss_feed_collection"

RSpec.describe Api::V0::RssFeedsController, type: :controller do  
  describe "GET #index" do
    it_should_behave_like("rss feed collection", :index)
  end

  describe "GET #search" do
    it_should_behave_like("rss feed collection", :search)
  end
end
