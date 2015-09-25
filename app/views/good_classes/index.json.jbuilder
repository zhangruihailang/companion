json.array!(@good_classes) do |good_class|
  json.extract! good_class, :id, :name, :parent_id
  json.url good_class_url(good_class, format: :json)
end
