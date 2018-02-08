class Mutations::UpdateProduct < GraphQL::Function
  argument :id, !types.String, prepare: ->(id, ctx){
    unless Product.where(id: id).exists?
      return GraphQL::ExecutionError.new("Product with id #{id} doesn't exist.")
    end
    id
  }
  argument :attributes, !Types::ExistingProductInput
  type Types::ProductType

  def call(obj, args, ctx)
    product = Product.find(args[:id])
    # ProductInput is of type InputObjectType:
    # http://www.rubydoc.info/gems/graphql/1.7.9/GraphQL/InputObjectType
    product.update_attributes(args[:attributes].to_h)
    product
  end
end
