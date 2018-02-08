require 'rails_helper'

describe "Single Product Query" do
  # from: http://graphql-ruby.org/schema/testing.html
  let(:context){ {} }
  let(:variables){ {} }
  let(:result){
    res = GraphqlMongoProductApiSchema.execute(
      query,
      context: context
      variables: variables
    )
    if res["errors"]
      pp res
    end
    res
  }
  let(:query) do
    <<-GRAPHQL
      query{
        product(id: $product_id){
          id
          title
        }
      }
    GRAPHQL
  end
end
