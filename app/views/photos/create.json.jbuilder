json.partial! 'status'

if @status[:code] == 200
  json.photo do
    json.id @photo.id
    json.image do
      json.thumb @photo.image.thumb.url
      json.full  @photo.image.full.url
    end
  end
end
