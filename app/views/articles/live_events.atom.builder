atom_feed do |feed|
  feed.title("Live Events at Santa Cruz Daily")
  feed.updated(@articles[0].created_at) if @articles.length > 0
  feed.link rel: "apple-touch-icon", href: "ico/apple-touch-icon.png"

  @articles.each do |post|
    feed.entry post, {published: post.publish_date, updated: post.updated_at}  do |entry|
      entry.title(post.title)
      unless post.image.blank?
        entry.link href: post.image.hero, rel:"enclosure", type:"image/jpeg"
      end
      entry.content(markdown(post.body), type: 'html')
      entry.author do |author|
        author.name(post.user.identities.presence ? "@" + post.user.identities.first.nickname : post.user.username ? "@" + post.user.username : post.email ? post.email : "@teammanda")
      end
    end
  end
end
