xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'Imagenary - photo blog'
    xml.description 'Live fast & take a photo'
    xml.link photos_url

    for photo in @photos
      xml.item do
        xml.title photo_url(photo)
        xml.description photo.comment
        xml.pubDate photo.created_at.to_s(:rfc822)
        xml.image photo_url(photo)
        xml.link photo_url(photo)
        xml.guid photo_url(photo)
      end
    end
  end
end