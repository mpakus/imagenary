json.status do
  json.(@status, :code, :msg)
end
if @status[:code] == 200
  json.photos @photos do |photo|
    json.id photo.id
    json.created_at photo.created_at
    json.latitude photo.latitude
    json.longitude photo.longitude
    json.tags []
    json.comment photo.comment
    json.image do
      json.thumb photo.image.thumb.url
      json.full  photo.image.full.url
      json.box  photo.image.box.url
    end
    json.author do
      json.id photo.user.id
      json.name  photo.user.name
    end
  end
end
