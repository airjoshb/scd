atom_feed do |feed|
  feed.title("Santa Cruz Daily")
  feed.updated(@articles[0].created_at) if @articles.length > 0
  feed.link :href=> "http://santacruzdaily.com", :rel => "canonical"
  feed.lan("en")
  feed.link :rel => "apple-touch-icon", :href => "ico/apple-touch-icon.png"


  @articles.each do |post|
    feed.entry post, {published: post.publish_date, updated: post.updated_at}  do |entry|
      entry.title(post.title)
      unless post.image.blank?
        entry.image(post.image)
      end
      entry.content(markdown(post.body), type: 'html')
      unless entry.author.blank?
        entry.author do |author|
          author.name(post.user.identities.presence ? post.user.identities.first.nickname : post.user.username ? post.user.username : post.email)
        end
      end
    end
  end
end

