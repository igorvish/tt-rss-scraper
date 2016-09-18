class RssFeed < ApplicationRecord

  def self.searchable_language; 'russian'; end # Язык построения лексем запроса
  def self.searchable_columns; [:title, :description]; end

end
