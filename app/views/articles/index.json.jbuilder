json.array!(@articles) do |article|
  json.extract! article, :id, :title, :subhead, :body, :slug, :origin, :image, :publish_date
  json.url article_url(article, format: :json)
end
