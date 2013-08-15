json.array!(@punches) do |punch|
  json.extract! punch, :from, :to, :project_id, :user_id
  json.url punch_url(punch, format: :json)
end
