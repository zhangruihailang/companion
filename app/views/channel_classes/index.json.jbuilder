json.array!(@channel_classes) do |channel_class|
  json.extract! channel_class, :id, :title, :intro, :picture
  json.url channel_class_url(channel_class, format: :json)
end
