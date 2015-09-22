json.array!(@topics) do |topic|
  json.extract! topic, :id, :user_id, :category_id, :channel_id, :title, :content
  json.url topic_url(topic, format: :json)
end
