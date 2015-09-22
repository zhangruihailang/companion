json.array!(@channels) do |channel|
  json.extract! channel, :id, :user_id, :title, :intro, :picture
  json.url channel_url(channel, format: :json)
end
