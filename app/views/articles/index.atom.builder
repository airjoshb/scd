atom_feed do |feed|
  feed.title("Santa Cruz Daily")
  feed.updated(@articles[0].created_at) if @articles.length > 0
  feed.link :href=> "http://santacruzdaily.com", :rel => "canonical"
  feed.language("en-US")
  feed.link :rel => "apple-touch-icon", :href => "ico/apple-touch-icon.png"


  @articles.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.title, type: 'og:title')
      entry.image(post.image)
      entry.content(markdown(post.body), type: 'html')
      entry.published(post.publish_date)
      entry.author do |author|
        author.name(post.user.identities.presence ? post.user.identities.first.nickname : post.user.username ? post.user.username : post.email)
      end
    end
  end
end

