atom_feed do |feed|
  feed.title("Santa Cruz Daily")
  feed.updated(@articles[0].created_at) if @articles.length > 0
  feed.link "http://santacruzdaily.com", :rel => "canonical"
  feed.description "Curated and personalized content about the best things to do in Santa Cruz"
  feed.link :rel => "apple-touch-icon", :href => "ico/apple-touch-icon.png"


  @articles.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content(markdown(post.body), type: 'html')
    end
  end
end

