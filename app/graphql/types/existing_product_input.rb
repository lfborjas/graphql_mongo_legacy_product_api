Types::ExistingProductInput = GraphQL::InputObjectType.define do
  name "ExistingProductInput"
  argument :slug, types.String
  #commenting these out for the sake of demo,
  #we could also argue that they should be derived
  #from categories or something
  #argument :is_men, types.Boolean
  #argument :is_women, types.Boolean
  #argument :in_stock, types.Boolean
  #argument :availability, types.String
  argument :title, types.String
  argument :type, types.String
  argument :sku, types.String
  argument :brand, types.String
  argument :brand_id, types.Int
  argument :description, types.String
  argument :price, types.Float
  argument :category_ids, types[types.Int]
  argument :brand_ids, types[types.Int]
  argument :rating, types.Float
end
