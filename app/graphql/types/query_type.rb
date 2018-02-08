Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  # TODO: remove me
  field :product, Types::ProductType do
    description "Get information about a single product"
    argument :id, types.String
    resolve ->(obj, args, ctx) {
      Product.find(args[:id])
    }
  end
end
