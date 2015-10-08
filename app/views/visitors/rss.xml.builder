#encoding: UTF-8

xml.instruct!
xml.rss(:version => "2.0", :"xmlns:g"=>"http://base.google.com/ns/1.0") do
  xml.channel do
    xml.link "http://santacruzdaily.com", :rel => "canonical"
    xml.title "Santa Cruz Daily"
    xml.description "Curated and personalized content about the best things to do in Santa Cruz"
    xml.link :rel => "apple-touch-icon", :href => "ico/apple-touch-icon.png"

    for a in @posts
      xml.item do
        xml.og :title, a.title
        xml.g :headline, a.title
        xml.og :description, markdown(a.body)
        xml.g :description, markdown(a.body)
        xml.og :url, "https://santacruzdaily.com#{article_path(a)}"
        xml.g :url, ("https://santacruzdaily.com#{article_path(a)}")
        xml.og :image, a.image
        xml.image a.image
        xml.og :locale, "en_US"
        xml.contentLocation "en_US"
        xml.article :published_time, a.publish_date
      end
    end
  end
end

