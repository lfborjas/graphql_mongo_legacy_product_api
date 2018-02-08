Types::NewProductInput = GraphQL::InputObjectType.define do
  name "NewProductInput"
  argument :slug, !types.String
  argument :is_men, types.Boolean, default_value: false
  argument :is_women, types.Boolean, default_value: true
  argument :title, !types.String
  argument :type, types.String, default_value: "simple"
  argument :sku, !types.String
  argument :brand, types.String
  argument :brand_id, types.Int
  argument :description, types.String
  argument :availability, types.String, default_value: "available"
  argument :in_stock, types.Boolean, default_value: true
  argument :price, !types.Float
  argument :category_ids, types[types.Int]
  argument :brand_ids, types[types.Int]
  argument :rating, types.Float
end
