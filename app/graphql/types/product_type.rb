Types::ProductType = GraphQL::ObjectType.define do
  name "Product"

  field :id, types.ID
  field :slug, types.String
  field :is_men, types.Boolean
  field :is_women, types.Boolean
  field :title, types.String
  field :type, types.String
  field :sku, types.String
  field :brand, types.String
  field :brand_id, types.Int
  field :description, types.String
  field :availability, types.String
  field :in_stock, types.Boolean
  field :price, types.Float
  field :category_ids, types[types.Int]
  field :brand_ids, types[types.Int]
  field :rating, types.Float
end
