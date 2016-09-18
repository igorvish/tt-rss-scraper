class RssFeedSerializer < ActiveModel::Serializer
  attributes \
    :id,
    :guid,
    :title,
    :link,
    :description,
    :published_at
end
