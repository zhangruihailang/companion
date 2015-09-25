json.array!(@goods) do |good|
  json.extract! good, :id, :title, :description, :price, :original_price, :freight, :user_id, :good_class_id
  json.url good_url(good, format: :json)
end
