json.array!(@activities) do |activity|
  json.extract! activity, :id, :title, :description, :starttime, :endtime, :place, :number_of_people, :pay_type, :average_cost, :user_id, :tags, :apply_up_limit
  json.url activity_url(activity, format: :json)
end
