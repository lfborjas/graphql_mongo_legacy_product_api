Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :updateProduct, function: Mutations::UpdateProduct.new
end
