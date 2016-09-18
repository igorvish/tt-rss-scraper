RSpec.shared_examples "rss feed collection" do |action|
  it "responds successfully with an HTTP 200 status code" do
    get action
    expect(response).to be_success
    expect(response).to have_http_status(200)
  end

  it "respond has rss_feeds array" do
    get action
    ret = JSON.parse(response.body)
    expect(ret['rss_feeds']).to be_kind_of(Array)
  end

  it "has pagination" do
    get action, params: {page: 2}
    ret = JSON.parse(response.body)
    expect(ret['meta']).to be_kind_of(Hash)
    expect(ret['meta']['current_page']).to eq(2)
  end
end
