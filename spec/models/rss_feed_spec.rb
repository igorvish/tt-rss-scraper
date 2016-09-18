require "rails_helper"

RSpec.describe RssFeed, :type => :model do
  it "serches by title and description" do
    RssFeed.create!(
      guid: '1',
      title: "Путин проголосовал на выборах в Госдуму", 
      description: "Президент России Владимир Путин в воскресенье, 18 сентября, проголосовал на выборах в Госдуму.",
      category: 'Политика'
    )
    RssFeed.create!(
      guid: '2',
      title: "Медведев с супругой проголосовал на выборах в Госдуму", 
      description: "Около 11:40 мск премьер вместе с супругой Светланой прибыл к избирательному участку",
      category: 'Политика'
    )
    RssFeed.create!(
      guid: '3',
      title: "Федерация санного спорта отказалась отбирать у России право на чемпионат мира", 
      description: "...",
      category: 'Выборы'
    )

    expect(RssFeed.basic_search('выборы').count('id')).to eq(2)
  end
end
