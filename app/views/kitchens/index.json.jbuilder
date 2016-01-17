json.array!(@kitchens) do |kitchen|
  json.extract! kitchen, :id, :name, :address
  json.url kitchen_url(kitchen, format: :json)
end
