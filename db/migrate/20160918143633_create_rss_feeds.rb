class CreateRssFeeds < ActiveRecord::Migration[5.0]
  def up
    create_table :rss_feeds do |t|
      t.string    :guid, null: false
      t.string    :title
      t.string    :link
      t.text      :description
      t.datetime  :published_at
      t.json      :enclosure
      t.string    :category
      t.timestamps
    end

    add_index(:rss_feeds, :guid, unique: true)
    execute "
      CREATE INDEX ON rss_feeds USING gin(to_tsvector('russian', title));
      CREATE INDEX ON rss_feeds USING gin(to_tsvector('russian', description));
    "
  end

  def down
    drop_table :rss_feeds
  end
end
